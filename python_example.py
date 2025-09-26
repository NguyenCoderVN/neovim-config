import 
from pathlib import Path


class TodoApp:
    def __init__(self, filename="todos.json"):
        self.file = Path(filename)
        self.todos = self.load()

    def load(self):
        if self.file.exists():
            return json.loads(self.file.read_text())
        return []

    def save(self):
        self.file.write_text(json.dumps(self.todos, indent=2))

    def add(self, task):
        self.todos.append({"task": task, "done": False})
        self.save()

    def complete(self, index):
        if 0 <= index < len(self.todos):
            self.todos[index]["done"] = True
            self.save()

    def show(self):
        for i, todo in enumerate(self.todos):
            status = "✓" if todo["done"] else " "
            print(f"{i+1}. [{status}] {todo['task']}")


if __name__ == "__main__":
    app = TodoApp()
    app.add("Write Python code")
    app.add("Test Todo app")
    app.complete(0)
    app.show()
