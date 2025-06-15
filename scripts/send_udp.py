import socket
import time

def send_udp_packet(message, ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Set a timeout for receiving the response
        sock.settimeout(5.0)
        
        # Send the message
        sock.sendto(message.encode(), (ip, port))
        print(f"Sent: {message}")
        
        # Wait for response
        print("Waiting for response...")
        data, addr = sock.recvfrom(1024)
        print(f"Received response from {addr}: {data.decode()}")
        
    except socket.timeout:
        print("No response received within timeout period")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        sock.close()

if __name__ == "__main__":
    SERVER_IP = "localhost"
    SERVER_PORT = 5000
    
    # Send a test message
    send_udp_packet("Hello from Python!", SERVER_IP, SERVER_PORT) 