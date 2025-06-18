import socket
import time
import sys

def send_udp_packet(message, ip, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            
        # Send the message
        sock.sendto(message.encode(), (ip, port))
        print(f"Sent: {message}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        sock.close()

if __name__ == "__main__":
    SERVER_IP = "localhost"
    SERVER_PORT = 5000
    
    # Get message from command line arguments or use default
    message = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Hello from Python!"
    
    # Send the message
    send_udp_packet(message, SERVER_IP, SERVER_PORT) 