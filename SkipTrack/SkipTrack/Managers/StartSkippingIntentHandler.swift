import Intents

class StartSkippingIntentHandler: NSObject, StartSkippingIntentIntentHandling {
    func handle(intent: StartSkippingIntentIntent, completion: @escaping (StartSkippingIntentIntentResponse) -> Void) {
        // Handle the intent - start the workout
        // You can post a notification or use a delegate to communicate with your app
        
        let response = StartSkippingIntentIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
    
    func confirm(intent: StartSkippingIntentIntent, completion: @escaping (StartSkippingIntentIntentResponse) -> Void) {
        let response = StartSkippingIntentIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
}