A dart library used for making a simple HTTP server.

This should be used for testing purposes and not for real production.

As you can see in the example it's still bare bones.

# Example

````dart
import 'package:simplehttp/simplehttp.dart';

void main() {
  final application = SimpleHttp(port: 8080);
  application.get('/', (request, response) {
    response.status(200).json({
      'Test': 1,
    });
  });

  application.get('/:id', (request, response) {
    print(request.segments()[0]);
    response.status(200);
  });

  application.post('/post', (request, response) async {
    print(await request.body());
  });

  application.start();
}

````