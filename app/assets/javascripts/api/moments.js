angular.module("api.moments", [])

.factory('Moments', ['RailsHttp', function(RailsHttp) {
	return {
		get: function(page) {
			var url = "/moments/_cards.json";
			return RailsHttp.get(url, false, { page: page });
		},
		getByTypeAndUser: function(page, user, kind) {
			var url = ["/users", user, "_cards"].join("/");
			return RailsHttp.get(url, false, { page: page, kind: kind });
		}
	};
}])

;