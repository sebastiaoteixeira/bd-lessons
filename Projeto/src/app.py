from flask import Flask, jsonify
import time

# Create a customized Flask class
class App(Flask):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.stats = {
                'start_time': time.time(),
                'requests': 0,
                'errors': 0
        }
    
    # Define a custom route decorator
    def route(self, rule, **options):
        def decorator(f):
            endpoint = options.pop('endpoint', f.__name__)
            def wrapper(*args, **kwargs):
                try:
                    self.stats['requests'] += 1
                    content = f(*args, **kwargs)
                    if content is None:
                        return jsonify({"status": "not found"}), 404
                    else:
                        return content
                except Exception as e:
                    self.stats['errors'] += 1
                    raise e
            # By default, strict_slashes is False
            options.setdefault('strict_slashes', False)
            self.add_url_rule(rule, endpoint=endpoint, view_func=wrapper, **options)
        return decorator

    def get_stats(self):
        return {
            'uptime': time.time() - self.stats['start_time'],
            'requests': self.stats['requests'],
            'errors': self.stats['errors']
        }
