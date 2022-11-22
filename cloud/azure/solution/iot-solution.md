# [Azure security baseline for Azure IoT Hub](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/iot-hub-security-baseline)
- NS-1: Implement security for internal traffic
- NS-2: Connect private networks together
- NS-3: Establish private network access to Azure services
- NS-4: Protect applications and services from external network attacks
- NS-6: Simplify network security rules

# [Quickstart: Send telemetry from a device to an IoT hub and monitor it with the Azure CLI](https://docs.microsoft.com/en-us/azure/iot-hub/quickstart-send-telemetry-cli)
- Prepare two CLI sessions
    - The first session **simulates an IoT device** that communicates with your IoT hub. (終端設備)
    - The second session either **monitors** the device in the first session, or sends messages, commands, and property updates. (後台)
- Create a simulated device in an IoT Hub
    - `az iot hub device-identity create -d simDevice -n findarts-iothub` (symmetric keys)
- Starts the simulated device, the device sends telemetry to your IoT hub and receives messages from it
    - `az iot device simulate -d simDevice -n findarts-iothub`
- Continuously monitors the simulated device
    - `az iot hub monitor-events --output table -p all -n findarts-iothub`
- Use the CLI to send a message
    - `az iot device c2d-message send -d simDevice --data "Hello World" --props "key0=value0;key1=value1" -n findarts-iothub`

# [Tutorial: Send device data to Azure Storage using IoT Hub message routing](https://docs.microsoft.com/en-us/azure/iot-hub/tutorial-routing?tabs=portal)

# Reference
- 架構
    <br><img src="https://cdn.plainconcepts.com/wp-content/uploads/2020/09/router-azf-1.png">
- [【 Cloud 】將 Azure IoT Hub 所接收到的數據透過 Azure Function 存入 Azure Digital Twins 再透過 Azure Event Grid 將警示資訊顯示於 Azure Indoor Map ( Node.js 版 )](https://learningsky.io/use-azure-iot-hub-azure-function-azure-event-grid-azure-digital-twins-to-update-an-azure-map-indoor-map-nodejs/)
- [Monitoring Azure IoT Hub data reference](https://learn.microsoft.com/en-us/azure/iot-hub/monitor-iot-hub-reference#connections)
    - [Resource logs](https://learn.microsoft.com/en-us/azure/iot-hub/monitor-iot-hub-reference#resource-logs)