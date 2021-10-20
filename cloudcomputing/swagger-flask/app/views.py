# views.py

from flask import render_template, request, jsonify, abort
from app import app

from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin
from apispec_webframeworks.flask import FlaskPlugin
from flask import Flask,jsonify,send_from_directory
from marshmallow import Schema, fields
from datetime import date

spec = APISpec( 
    title='Flask-api-swagger-doc',
    version='1.0.0.',
    openapi_version='3.0.2',
    plugins=[FlaskPlugin(),MarshmallowPlugin()]
)

articles = [
    {
        'id': 1,
        'title': 'Article one',
        'body': 'Lorem ipsum', 
        'author': 'Gabo',
        'create_date': date(2021,10,4)
    },
    {
        'id': 2,
        'title': 'Article two',
        'body': 'Lorem ipsum', 
        'author': 'Perez', 
        'create_date': date(2021,10,12)
    }
]

books = [
    {
        'id': 1,
        'title': 'La hojarasca',
        'description': 'Good one', 
        'author': 'Gabo'
    },
    {
        'id': 2,
        'title': 'El coronel no tiene quien le escriba',
        'description': 'Interesting', 
        'author': 'Gabo'
    }
]

@app.route('/api/swagger.json')
def create_swagger_spec():
        return jsonify(spec.to_dict())

class BookResponseSchema(Schema):
        id = fields.Int()
        title = fields.Str()
        description = fields.Str()
        author = fields.Str()

class BookListResponseSchema(Schema):
        book_list = fields.List(fields.Nested(BookResponseSchema))

class deleteSchema(Schema):
	result = fields.Boolean()

@app.route('/books')
def bookss():
    """Get List of Books
        ---
        get:
            description: Get List of Books
            responses:
                200:
                    description: Return an book list
                    content:
                        application/json:
                            schema: BookListResponseSchema
    """

    return BookListResponseSchema().dump({'book_list':books})

@app.route('/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    """Get a Book
        ---
        get:
            description: Get a Book
            responses:
                200:
                    description: Return a
                    content:
                        application/json:
                            schema: BookListResponseSchema
    """
    book = [book for book in books if book['id'] == book_id]
    if len(book) == 0:
        abort(404)
    return jsonify({'book': book[0]})

# Add new book
# For testing: curl -i -H "Content-Type: application/json" -X POST -d '{"title":"El libro"}' http://localhost:5000/books
@app.route('/addBook', methods=['POST'])
def create_book():
    """Create a Book
        ---
        post:
            description: Create a Book
            responses:
                200:
                    description: Return a
                    content:
                        application/json:
                            schema: BookListResponseSchema
    """
    if not request.json or not 'title' in request.json:
        abort(400)
    book = {
        'id': articles[-1]['id'] + 1,
        'title': request.json['title'],
        'description': request.json.get('description', ""),
        'author': request.json.get('author', "")
    }
    books.append(book)
    return jsonify({'new book': book}), 201

# Edit a Book
# For testing: curl -i -H "Content-Type: application/json" -X PUT -d '{"author":"Jorgito"}' http://localhost:5000/books/2
@app.route('/books/<int:book_id>', methods=['PUT'])
def update_book(book_id):
    """Update a Book
        ---
        put:
            description: Update a Book
            responses:
                200:
                    description: Return a
                    content:
                        application/json:
                            schema: BookListResponseSchema
    """
    book = [book for book in books if book['id'] == book_id]
    if len(book) == 0 or not request.json:
        abort(404)
    book[0]['title'] = request.json.get('title', book[0]['title'])
    book[0]['description'] = request.json.get('description', book[0]['description'])
    book[0]['author'] = request.json.get('author', book[0]['author'])
    return jsonify({'book': book[0]})

# Delete a Book
# For testing: curl -i -H "Content-Type: application/json" -X DELETE http://localhost:5000/books/1
@app.route('/delbooks/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    """Delete a Book
        ---
        delete:
            description: Delete a Book
            responses:
                200:
                    description: Return a
                    content:
                        application/json:
                            schema: deleteSchema
    """
    book = [book for book in books if book['id'] == book_id]
    if len(book) == 0:
        abort(404)
    books.remove(book[0])
    return jsonify({'result': True})

with app.test_request_context():
    spec.path(view=bookss)
    spec.path(view=get_book)
    spec.path(view=update_book)
    spec.path(view=create_book)
    spec.path(view=delete_book)

@app.route('/docs')
@app.route('/docs/<path:path>')
def swagger_docs(path=None):
    if not path or path == 'index.html':
        return render_template('index.html',base_url='/docs')
    else:
        return send_from_directory('static',path)
