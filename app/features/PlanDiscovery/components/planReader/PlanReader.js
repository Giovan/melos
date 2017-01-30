import React, { Component, PropTypes } from 'react'
import ActionCreators from '../../actions/creators'
import { FormattedMessage } from 'react-intl'
import PlanNavigation from './PlanNavigation'
import PlanArrows from './PlanArrows'

class PlanReader extends Component {

	constructor(props) {
		super(props)
	}


	render() {
		return (
			<div>
				<PlanNavigation />
				Plan reader
				<PlanArrows />
			</div>
		)
	}
}

PlanReader.propTypes = {

}

PlanReader.defaultProps = {

}

export default PlanReader