import React, { Component } from 'react'
import { connect } from 'react-redux'
import ActionCreators from '../features/Bible/actions/creators'
import Bible from '../features/Bible/components/Bible'

class BibleView extends Component {

	localizedLink(link) {
		const { params, serverLanguageTag } = this.props
		const languageTag = params.lang || serverLanguageTag || 'en'

		if (['en', 'en-US'].indexOf(languageTag) > -1) {
			return link
		} else {
			return `/${languageTag}${link}`
		}
	}

	render() {
		return (
			<Bible {...this.props} localizedLink={::this.localizedLink} />
		)
	}
}

function mapStateToProps(state) {
	return {
		auth: state.auth,
		bible: state.bibleReader,
		hosts: state.hosts,
		serverLanguageTag: state.serverLanguageTag
	}
}

export default connect(mapStateToProps, null)(BibleView)
