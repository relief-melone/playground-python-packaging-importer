from fastapi import FastAPI
from pydantic import BaseModel
from src import agent


class ChatRequest(BaseModel):
    input: str

app = FastAPI()

@app.post("/api/chat")
async def chat_endpoint(request: ChatRequest):
    response = agent.chat(request.input)
    return { "repsonse": response }

