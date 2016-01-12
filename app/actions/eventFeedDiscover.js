import { getClient } from 'youversion-node-api'
import { handleResponse } from './common'

export const EVENT_FEED_DISCOVER_REQUEST = 'EVENT_FEED_DISCOVER_REQUEST'
export const EVENT_FEED_DISCOVER_SUCCESS = 'EVENT_FEED_DISCOVER_SUCCESS'
export const EVENT_FEED_DISCOVER_FAILURE = 'EVENT_FEED_DISCOVER_FAILURE'

var EventsApi = getClient('events')

function eventFeedDiscoverRequest() {
	return {
		type: EVENT_FEED_DISCOVER_REQUEST
	}
}

function eventFeedDiscoverSuccess(data) {
	return {
		type: EVENT_FEED_DISCOVER_SUCCESS,
		data: data
	}
}
 
function eventFeedDiscoverFailure(error) {
	return {
		type: EVENT_FEED_DISCOVER_FAILURE,
		error: error
	}
}

export function fetchEventFeedDiscover() {
	return dispatch => {
		dispatch(eventFeedDiscoverRequest())
		return EventsApi
			.call("search")
			.setVersion("3.2")
			.setEnvironment("staging")
			.params({query: 'Life.Church'})	
			.get()
			.then((data) => {
				handleResponse(data).then((data) => {
					dispatch(eventFeedDiscoverSuccess(data))
				}, (error) => {
					dispatch(eventFeedDiscoverFailure(error))
				})
			}, (error) => {
				dispatch(eventFeedDiscoverFailure(error))
			})
	}
}