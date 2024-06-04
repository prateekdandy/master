@isTest
global class SnowFlakeControllerMock implements HttpCalloutMock{
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(
				'{"test":"test"}');
		res.setStatusCode(200);
		return res;
	}
}