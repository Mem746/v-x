from fastapi import FastAPI, Path, HTTPException
from pydantic import BaseModel

app = FastAPI()

users = []

class User(BaseModel):
    id: int
    username: str
    age: int

@app.get('/users')
async def get_users():
    return users

@app.post('/user/{username}/{age}')
async def create_user(username: str, age: int):
    user_id = len(users) + 1
    user = User(id=user_id, username=username, age=age)
    users.append(user)
    return user

@app.put('/user/{user_id}/{username}/{age}')
async def update_user(user_id: int, username: str, age: int):
    for user in users:
        if user.id == user_id:
            user.username = username
            user.age = age
            return user
    raise HTTPException(status_code=404, detail="User was not found")

@app.delete('/user/{user_id}')
async def delete_user(user_id: int):
    for user in users:
        if user.id == user_id:
            users.remove(user)
            return user
    raise HTTPException(status_code=404, detail="User was not found")
