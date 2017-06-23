import { createStore, applyMiddleware, compose } from 'redux'
import thunk from 'redux-thunk'
import { syncHistory } from 'react-router-redux'

import youversionAuth from '@youversion/api-redux/lib/middleware/youversionAuth'
// import youversionApi from '@youversion/api-redux/lib/middleware/youversionCustomApi'
import youversionApi from '../../middleware/youversionApi'
// import youversionAuth from '../../middleware/youversionAuth'

import rootReducer from './reducer'

export default function configureStore(initialState, history, logger) {
	const reduxRouterMiddleware = syncHistory(history)

	let finalCreateStore = null

	if (logger !== null) {
		finalCreateStore = compose(
			applyMiddleware(thunk, youversionApi, youversionAuth, reduxRouterMiddleware, logger)
		)(createStore)
	} else {
		finalCreateStore = compose(
			applyMiddleware(thunk, youversionApi, youversionAuth, reduxRouterMiddleware)
		)(createStore)
	}

	return finalCreateStore(rootReducer, initialState)
}
