
import os, sys

from langchain.agents import structured_output
from langchain.agents.structured_output import ProviderStrategy, ToolStrategy
from langchain_core.language_models import BaseChatModel
from langchain.agents import create_agent
from langchain_ollama import ChatOllama
from langchain_openai import ChatOpenAI

from pypacking.main import basic_schema

if not os.environ.get("OPENAI_API_KEY"):
    print("Please provide the env var OPENAPI_API_KEY")
    sys.exit(1)

llm = ChatOpenAI(
    model = "gpt-5-nano"
)

agent = create_agent(
    model=llm,
    response_format=ProviderStrategy(basic_schema)
)


def chat(input:str) -> str:
    result = agent.invoke({ "messages": [
        { "role": "user", "content": input}
    ]})
    return result["structured_response"]

