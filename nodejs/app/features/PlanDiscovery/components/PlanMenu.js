import React, { PropTypes } from 'react'
import { FormattedMessage } from 'react-intl'
import { Link } from 'react-router'
import PopupMenu from '../../../components/PopupMenu'


function PlanMenu({ subscriptionLink, aboutLink, onCatchUp }) {
	return (
		<PopupMenu>
			<ul>
				<Link to={`${subscriptionLink}`}>
					<li>
						<FormattedMessage id='plans.overview' />
					</li>
				</Link>
				<Link to={`${subscriptionLink}/edit`}>
					<li>
						<FormattedMessage id='plans.settings' />
					</li>
				</Link>
				<Link to={`${aboutLink}`}>
					<li>
						<FormattedMessage id='features.EventEdit.features.preview.components.PreviewTypePlan.info' />
					</li>
				</Link>
				<Link to={`${subscriptionLink}/calendar`}>
					<li>
						<FormattedMessage id='plans.month' />
					</li>
				</Link>
				<a tabIndex={0} onClick={onCatchUp}>
					<li>
						<FormattedMessage id='plans.catch me up' />
					</li>
				</a>
			</ul>
		</PopupMenu>
	)
}

PlanMenu.propTypes = {
	subscriptionLink: PropTypes.string.isRequired,
	aboutLink: PropTypes.string.isRequired,
	onCatchUp: PropTypes.func.isRequired
}

export default PlanMenu
