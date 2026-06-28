# FastAPI Main

main.py

````python
from fastapi import Depends, FastAPI
from .dependencies import get_query_token, get_token_header
from .internal import admin
from .routers import users

app = FastAPI(dependencies=[Depends(get_query_token)])

app.include_router(users.router)

@app.get("/")
async def root():
    return {"message": "Hello Bigger Applications!"}
    ```
````

## Configure the entrypoint in pyproject.toml

```toml
[tool.poetry.scripts]
app = "app.main:app"
```
