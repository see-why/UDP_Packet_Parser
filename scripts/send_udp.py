import socket
import time

def send_udp_packet(message, ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.sendto(message.encode(), (ip, port))
        print(f"Sent: {message}")
    except Exception as e:
        print(f"Error sending packet: {e}")
    finally:
        sock.close()

if __name__ == "__main__":
    SERVER_IP = "localhost"
    SERVER_PORT = 5000
    
    # Send a test message
    send_udp_packet("Hello from Python!", SERVER_IP, SERVER_PORT) 