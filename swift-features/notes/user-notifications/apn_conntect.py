import jwt
import datetime
import hyper
import json

# Configuration

REMOTE_SERVER_URL = "api.sandbox.push.apple.com"  # Replace with your remote server URL

def generate_jwt():
    # JWT Header
    headers = {
        "alg": "ES256",
        "kid": "" # Private Key ID
    }

    # JWT Payload (Claims)
    payload = {
        "iss": "",  # Subject (User ID)
        "iat": datetime.datetime.utcnow(),  # Issued at time
    }

    # Encode JWT
    secretKey = read_text_file()
    token = jwt.encode(payload, secretKey, algorithm="ES256", headers=headers)
    return token

def make_alert_push(token):
    # Authentication header
    request_url = "/3/device/7d7fa44adf0e206ea06e5813898e9bf563893762834a8b2d39954bc1c822346c"
    headers = {
        "authorization": f"bearer {token}",
        "apns-push-type": "alert",
        "apns-topic": "com.postoevie.CryptoTracker"
    }
    body = { "aps" : { "alert" : "Hello" } }
    user_encode_data = json.dumps(body, indent=2).encode('utf-8')

    # Send GET request
    c = hyper.HTTP20Connection(REMOTE_SERVER_URL, port=443)
    c.request('POST', request_url, headers=headers, body=user_encode_data)
    response = c.get_response()

    print("Response Status Code:", response.status)
    print("Response headers:", response.headers)
    print("Response body:", response.read())

def make_background_push(token):
    # Authentication header
    request_url = "/3/device/7d7fa44adf0e206ea06e5813898e9bf563893762834a8b2d39954bc1c822346c"
    headers = {
        "authorization": f"bearer {token}",
        "apns-push-type": "background",
        "apns-priority": "5",
        "apns-topic": "com.postoevie.CryptoTracker"
    }
    body = {
        "aps" : {
            "content-available" : 1
        },
        "event" : "condition_triggered",
    }

    user_encode_data = json.dumps(body, indent=2).encode('utf-8')

    # Send GET request
    c = hyper.HTTP20Connection(REMOTE_SERVER_URL, port=443)
    c.request('POST', request_url, headers=headers, body=user_encode_data)
    response = c.get_response()

    print("Response Status Code:", response.status)
    print("Response headers:", response.headers)
    print("Response body:", response.read())

def read_text_file(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            content = file.read()
            return content
    except FileNotFoundError:
        return "Error: File not found."
    except Exception as e:
        return f"Error: {e}"

if __name__ == "__main__":
    jwt_token = generate_jwt()
    make_background_push(jwt_token)
    #make_alert_push(jwt_token)