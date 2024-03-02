
import messagingClient from './Messaging';

class App {

    constructor() {
    }

    initialize() {
        // First, connect to the Solace Message Broker
        messagingClient.connectWithPromise().then(response => {
            console.log("Succesfully connected to Solace Cloud.", response);
            // Now that we are successfully connected, register our message handler
            messagingClient.registerMessageHandler(app.messageHandler.bind(this));
        }).catch(error => {
            console.log("Unable to establish connection with Solace Cloud", error);
        });
    }

    messageHandler(topicString: string, messageString: string) {
        console.log("New message on topic:", topicString, "::", messageString);
        // Here is where you add code to handle the message
        switch (topicString) {
            case 'SomeTopic': {
                const message = JSON.parse(messageString);
                console.log("Message as object", message);
                break;
            }
            default: {
                console.warn("Unexpected topic", topicString);
                break;
            }
        }
    }

    publishMessage(topic: string, message: string) {
        messagingClient.publish(topic, message);
    }

    subscribeToTopic(topic: string) {
        messagingClient.subscribe(topic);
    }
}

const app = new App();
export default app;