#include "nw/Factory.h"
#include "log/Logging.hpp"
#include <memory>
#include <sstream>
#include <thread>
#include <vector>

namespace chrono = std::chrono;

static std::unique_ptr<merci::nw::IServer> CreateServer() {
    return merci::nw::Factory::CreateServer(12345);
};

static std::unique_ptr<merci::nw::IClient> CreateClient() {
    return merci::nw::Factory::CreateClient("localhost", 12345, 0);
};

static void Sleep() { std::this_thread::sleep_for(chrono::milliseconds(5)); }

void ServerShouldCountMultipleClients() {
    std::ostringstream buffer;
    buffer << "Test: ServerShouldCountMultipleClients\n";
    auto server = CreateServer();
    std::vector<std::unique_ptr<merci::nw::IClient>> clients;
    for (int i = 0; i < 5; i++) clients.emplace_back(CreateClient());
    Sleep();
    buffer << "Client count: " << server->GetClientCount();
    merci::logging::INFO(buffer.str());
}

void SendMessageFromClientToServerShouldProduceSameMessage() {
    std::ostringstream buffer;
    buffer << "Test: SendMessageFromClientToServerShouldProduceSameMessage\n";
    auto server = CreateServer();
    auto client = CreateClient();
    std::string message("Test message");

    // Send client->server
    client->Send(message);

    Sleep();

    buffer << "Before popmsgs: server->HasMessages: " << server->HasMessages()
           << "client->HasMessages: " << client->HasMessages() << "\n";

    auto receivedMessage = server->PopMessage().first;
    buffer << "is correct message: " << (message == receivedMessage) << "\n";

    buffer << "After popmsgs: server->HasMessages: " << server->HasMessages()
           << "client->HasMessages: " << client->HasMessages() << "\n";
    merci::logging::INFO(buffer.str());
}

void SendMessageFromServerToClientShouldProduceSameMessage() {
    std::ostringstream buffer;
    buffer << "Test: SendMessageFromServerToClientShouldProduceSameMessage\n";
    auto server = CreateServer();
    auto client = CreateClient();
    std::string message("Test message");

    // Sleep for a bit so that server has time to
    // receive client announcement message
    Sleep();

    // Send from server to client
    // TODO: get client ID from server itself
    buffer << "server->GetClientCount: " << server->GetClientCount() << "\n";
    server->SendToClient(message, server->GetClientIdByIndex(0));
    Sleep();
    buffer << "server->hasMessage: " << server->HasMessages() << "\n";

    auto receivedMessage = client->PopMessage();
    buffer << "is correct message: " << (message == receivedMessage) << "\n";

    buffer << "After popmsgs: server->HasMessages: " << server->HasMessages()
           << "client->HasMessages: " << client->HasMessages() << "\n";
    merci::logging::INFO(buffer.str());
}
int main(int argc, char* argv[]) {
    ServerShouldCountMultipleClients();
    SendMessageFromClientToServerShouldProduceSameMessage();
    SendMessageFromServerToClientShouldProduceSameMessage();
}