import React, { PropTypes } from 'react'

import SubscribeUserAction from './SubscribeUserAction'
import SaveForLaterAction from './SaveForLaterAction'

function PlanActionButtons({ id, planLinkNode, subLinkBase, isSubscribed, isSaved }) {
	return (
		<div style={{ marginTop: 30, fontSize: 12 }}>
			<div className='row collapse text-center'>
				<div className='columns small-12'>
					<SubscribeUserAction
						id={id}
						isSubscribed={isSubscribed}
						subLinkBase={subLinkBase}
						style={{ display: 'inline-block' }}
					/>
				</div>
			</div>
			<div className='row collapse text-center'>
				<div className='columns small-12'>
					<SaveForLaterAction
						id={id}
						isSaved={isSaved}
					/>
					&nbsp;&bull;&nbsp;
					{ planLinkNode }
				</div>
			</div>
		</div>
	)
}

PlanActionButtons.propTypes = {
	id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
	planLinkNode: PropTypes.node.isRequired,
	subLinkBase: PropTypes.string.isRequired,
	isSubscribed: PropTypes.bool.isRequired,
	isSaved: PropTypes.bool.isRequired,
}

export default PlanActionButtons
