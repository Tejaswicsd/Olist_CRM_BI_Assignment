import streamlit as st
import requests
import base64
import cv2
import numpy as np
import tempfile
import os
from PIL import Image
from io import BytesIO

# --- Page Configuration ---
st.set_page_config(
    page_title="Underwater Object Detection",
    page_icon="🐠",
    layout="wide"
)

# --- Roboflow Configuration ---
# IMPORTANT: Replace this with YOUR OWN Private API Key from Roboflow
API_KEY = "A5fh9Ksz9cmItCgrpHNb"
MODEL_ID = "ruod-tcoz3-ieqw3/1"

def get_prediction(image):
    """Sends image to Roboflow API with debug logging."""
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")
    
    url = f"https://detect.roboflow.com/{MODEL_ID}?api_key={API_KEY}"
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    
    try:
        response = requests.post(url, data=img_str, headers=headers)
        
        if response.status_code != 200:
            if response.status_code == 403:
                st.error("403 Forbidden: Check your Roboflow API Key and credits.")
            elif response.status_code == 401:
                st.error("401 Unauthorized: Invalid API Key.")
            else:
                st.error(f"API Error {response.status_code}: {response.text}")
            return None
            
        return response.json()
    except Exception as e:
        st.error(f"Connection Error: {e}")
        return None

def draw_boxes(image, predictions, threshold):
    """Draws detection boxes on the image."""
    img_array = np.array(image)
    img_bgr = cv2.cvtColor(img_array, cv2.COLOR_RGB2BGR)
    
    for p in predictions.get('predictions', []):
        if p['confidence'] < threshold:
            continue
            
        x1 = int(p['x'] - p['width'] / 2)
        y1 = int(p['y'] - p['height'] / 2)
        x2 = int(p['x'] + p['width'] / 2)
        y2 = int(p['y'] + p['height'] / 2)
        
        cv2.rectangle(img_bgr, (x1, y1), (x2, y2), (0, 255, 0), 3)
        label = f"{p['class']} {p['confidence']:.2f}"
        cv2.putText(img_bgr, label, (x1, y1 - 10), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
                    
    return cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

# --- UI Setup ---
st.title("🌊 Underwater Object Detection")
st.sidebar.title("Configuration")

conf_threshold = st.sidebar.slider("Confidence Threshold", 0.0, 1.0, 0.40, 0.05)
app_mode = st.sidebar.selectbox("Choose the input type:", ["Image", "Video"])

# ---------------- IMAGE MODE ----------------
if app_mode == "Image":
    uploaded_file = st.file_uploader("Upload an image...", type=["jpg", "jpeg", "png"])
    
    if uploaded_file is not None:
        image = Image.open(uploaded_file)

        col1, col2 = st.columns(2)

        with col1:
            st.image(image, caption="Uploaded Image", use_column_width=True)

        with col2:
            with st.spinner("Analyzing..."):
                results = get_prediction(image)

                if results and 'predictions' in results:
                    annotated_image = draw_boxes(image, results, conf_threshold)
                    st.image(annotated_image, caption="Detected Objects", use_column_width=True)

                    st.subheader("Results")
                    for p in results['predictions']:
                        if p['confidence'] >= conf_threshold:
                            st.write(f"✅ **{p['class']}**: {p['confidence']:.2%}")

# ---------------- VIDEO MODE ----------------
elif app_mode == "Video":
    uploaded_file = st.file_uploader("Upload a video...", type=["mp4", "mov", "avi"])
    
    if uploaded_file is not None:
        tfile = tempfile.NamedTemporaryFile(delete=False) 
        tfile.write(uploaded_file.read())
        video_path = tfile.name

        cap = cv2.VideoCapture(video_path)
        st_frame = st.empty()

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break
            
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            pil_img = Image.fromarray(frame_rgb)

            results = get_prediction(pil_img)
            
            if results:
                annotated_frame = draw_boxes(pil_img, results, conf_threshold)
                st_frame.image(annotated_frame, channels="RGB", use_column_width=True)

        cap.release()
        os.remove(video_path)
