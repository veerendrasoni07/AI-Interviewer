from dotenv import load_dotenv
import sys
import json
load_dotenv()
from langchain_core.prompts import PromptTemplate
from langchain_huggingface import HuggingFaceEndpoint,ChatHuggingFace
from langchain_core.output_parsers import PydanticOutputParser
from pydantic import BaseModel



llm = HuggingFaceEndpoint(
    repo_id="mistralai/Mistral-7B-Instruct-v0.2",
    task="text-generation"
)
model = ChatHuggingFace(llm=llm)

class Report(BaseModel):
    tech_stack:str
    accuracy:int
    weak_areas:list[str]
    strong_areas:list[str]
    improvements:list[str]
    tips:list[str]

parser = PydanticOutputParser(pydantic_object=Report)
template = PromptTemplate(
    template="""You are an expert who analyse the complete conversation that 
    given to you and based on that you generate the best possible report in the specified format \n {context} \n {format_instruction} """,
    input_variables=['context'],
    partial_variables= {"format_instruction":parser.get_format_instructions()}
)


def reportGenerator(conversation_text):
    simple_chain = template | model | parser
    result = simple_chain.invoke({
            "context":conversation_text
    })
    print(result.model_dump_json())
    sys.stdout.flush()

def get_data():
    input_data = sys.stdin.read()
    if not input_data:
        return None
    else:
        return json.loads(input_data)


if  __name__ == "__main__":
    convo = get_data()
    reportGenerator(convo["conversation"])




    

# @app.post('/api/generate-interview-report')
# async def interviewReport(data:Conversation):
#     try:
#         simple_chain = template | model | parser
#         result = simple_chain.invoke({
#             "context":data.convo
#         })
#         return {
#             "report":result
#         }
#     except Exception as e:
#         HTTPException(detail=e,status_code=500)
    
