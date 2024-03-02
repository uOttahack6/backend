import { connect, MqttClient } from "mqtt";
import msgOptions from "./messaging-options";

const options = msgOptions();

function messaging() {
    let client: MqttClient;

    // Connect to the message broker
    function connectWithPromise() {
        return new Promise((resolve, reject) => {
            console.log(options)
            if (!options.host) {
                reject("No host defined");
            } else {
                try {
                    client = connect(options.host, options);
                } catch (err) {
                    console.log("error connecting!");
                    reject(err);
                }

                client.on('connect', function () {
                    console.log("Connected to broker!");
                    resolve("Connected!");
                });
            }
        });
    }

    // Subscribe to a topic on to the broker
    function subscribe(topicName: string) {
        client.subscribe(topicName, function (err) {
            if (err) {
                console.error("Error subscribing to", topicName, err);
            }
        });
    }

    // Publish a message to the broker
    function publish(topicName: string, message: string) {
        client.publish(topicName, message, function (err) {
            if (err) {
                console.error("Error subscribing to", topicName, err);
            }
        });
    }

    // Register a function to handle received messages
    function registerMessageHandler(handler: (topic: string, message: string) => void) {
        client.on('message', function (topic, message) {
            handler(topic.toString(), message.toString());
        });
    }

    return {
        connectWithPromise: connectWithPromise,
        subscribe: subscribe,
        publish: publish,
        registerMessageHandler: registerMessageHandler
    }
}

let messagingClient = messaging();
export default messagingClient;