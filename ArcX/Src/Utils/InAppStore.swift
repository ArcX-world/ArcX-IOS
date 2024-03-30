//
// Created by MAC on 2023/12/15.
//

import StoreKit

public protocol ReceiptValidator: AnyObject {
    func validate(transaction: SKPaymentTransaction, completion: @escaping (Result<Any, Error>) -> Void)
}

class InAppStore: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    typealias InAppProductRequestCallback = (ProductResult) -> Void
    typealias InAppProductPaymentCallback = (Result<SKPaymentTransaction, Error>) -> Void

    struct InAppProductRequest {
        let request: SKProductsRequest
        var completionHandlers: [InAppProductRequestCallback]
    }

    struct ProductResult {
        let products: Set<SKProduct>
        let invalidProductIDs: Set<String>
        let error: Error?
    }

    struct InAppPayment {
        let payment: SKPayment
        let completionHandler: InAppProductPaymentCallback
    }


    static let `default` = InAppStore()

    weak var receiptValidator: ReceiptValidator?

    private var productRequests: [Set<String>: InAppProductRequest] = [:]
    private var payments: [InAppPayment] = []
    private var receiptRefreshRequest: SKReceiptRefreshRequest?
    private var receiptRefreshCallback: ((Result<Data, Error>) -> Void)?


    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }


    func retrieveProductInfo(_ productIds: Set<String>, completion: @escaping InAppProductRequestCallback) -> InAppProductRequest {
        if productRequests[productIds] == nil {
            let request = SKProductsRequest(productIdentifiers: productIds)
            request.delegate = self
            productRequests[productIds] = InAppProductRequest(request: request, completionHandlers: [ completion ])
            request.start()
        } else {
            productRequests[productIds]!.completionHandlers.append(completion)
        }
        return productRequests[productIds]!
    }

    func purchaseProduct(_ productId: String, applicationUsername: String, completion: @escaping (Result<Any, Error>) -> Void) {
        assert(receiptValidator != nil, "receiptValidator can not be nil.")

        retrieveProductInfo(Set([ productId ])) { result in
            if let product = result.products.first {
                self.purchase(product: product, applicationUsername: applicationUsername) { result in
                    if case .success(let transaction) = result {
                        self.receiptValidator?.validate(transaction: transaction) { result in
                            if case .success = result {
                                SKPaymentQueue.default().finishTransaction(transaction)
                            }
                            completion(result)
                        }
                    }
                    else if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                }
            }
            else if let error = result.error {
                completion(.failure(error))
            } else if let invalidProductId = result.invalidProductIDs.first {
                let userInfo = [ NSLocalizedDescriptionKey: "Invalid product id: \(invalidProductId)" ]
                let error = NSError(domain: SKErrorDomain, code: SKError.paymentInvalid.rawValue, userInfo: userInfo)
                completion(.failure(error))
            }
        }
    }

    func fetchReceipt(forceRefresh: Bool, completion: @escaping (Result<Data, Error>) -> Void) {
        if let receiptData = appStoreReceiptData, forceRefresh == false {
            completion(.success(receiptData))
        } else {
            receiptRefreshCallback = completion
            receiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
            receiptRefreshRequest!.delegate = self
            receiptRefreshRequest!.start()
        }
    }

    func finishTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }


    private func purchase(product: SKProduct, applicationUsername: String, completion: @escaping InAppProductPaymentCallback) {
        let payment = SKMutablePayment(product: product)
        payment.applicationUsername = applicationUsername
        payments.append(InAppPayment(payment: payment, completionHandler: completion))
        SKPaymentQueue.default().add(payment)
    }

    private var appStoreReceiptData: Data? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
            if let data = try? Data(contentsOf: appStoreReceiptURL) {
                return data
            }
        }
        return nil
    }


    // MARK: - SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            let result = ProductResult(products: Set(response.products), invalidProductIDs: Set(response.invalidProductIdentifiers), error: nil)
            if let (productIdentifiers, request) = self.productRequests.first(where: { $1.request == request }) {
                for completion in request.completionHandlers {
                    completion(result)
                }
                self.productRequests[productIdentifiers] = nil
            }
        }
    }

    func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            if let callback = receiptRefreshCallback {
                if let data = appStoreReceiptData {
                    callback(.success(data))
                } else {
                    let userInfo = [ NSLocalizedDescriptionKey: "no receipt data" ]
                    let error = NSError(domain: SKErrorDomain, code: SKError.unknown.rawValue, userInfo: userInfo)
                    callback(.failure(error))
                }
            }
            receiptRefreshCallback = nil
            receiptRefreshRequest = nil
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            DispatchQueue.main.async {
                let result = ProductResult(products: Set<SKProduct>(), invalidProductIDs: Set<String>(), error: error)
                if let (productIdentifiers, request) = self.productRequests.first(where: { $1.request == request }) {
                    for completion in request.completionHandlers {
                        completion(result)
                    }
                    self.productRequests[productIdentifiers] = nil
                }
            }
        }
        else if request is SKReceiptRefreshRequest {
            receiptRefreshCallback?(.failure(error))
            receiptRefreshCallback = nil
            receiptRefreshRequest = nil
        }
    }

    // MARK: - SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let transactionProductId = transaction.payment.productIdentifier
            if let paymentIndex = payments.firstIndex(where: { $0.payment.productIdentifier == transactionProductId }) {
                let payment = payments[paymentIndex]

                if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                    payment.completionHandler(.success(transaction))
                    payments.remove(at: paymentIndex)
                }
                else if transaction.transactionState == .failed {
                    if let error = transaction.error {
                        payment.completionHandler(.failure(error))
                    } else {
                        let userInfo = [ NSLocalizedDescriptionKey: "Unknown error" ]
                        let error = NSError(domain: SKErrorDomain, code: SKError.unknown.rawValue, userInfo: userInfo)
                        payment.completionHandler(.failure(error))
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                    payments.remove(at: paymentIndex)
                }
            } else {
                if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                    receiptValidator?.validate(transaction: transaction) { result in
                        if case .success = result {
                            SKPaymentQueue.default().finishTransaction(transaction)
                        }
                    }
                }
                else if transaction.transactionState == .failed {
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            }

        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {

    }


}