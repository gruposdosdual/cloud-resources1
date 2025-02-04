from fastapi import FastAPI
from routes import task_router

app = FastAPI()
app.include_router(task_router)

@app.get("/")
def read_root():
    return {"message": "Task Management API"}