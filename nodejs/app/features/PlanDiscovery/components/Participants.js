import React, { PropTypes } from 'react'
import CustomScroll from 'react-custom-scroll'
import LazyImage from '../../../components/LazyImage'
import User from '../../../components/User'
import { PLAN_DEFAULT } from '../../../lib/imageUtil'

function renderUser(friend) {
	const src = friend && friend.user_avatar_url ? friend.user_avatar_url.px_48x48 : ''
	return (
		<div className='vertical-center item' key={friend.id}>
			<User
				avatarLetter={friend.first_name ? friend.first_name.charAt(0) : null}
				src={src}
				width={36}
				heading={friend.name ? friend.name : null}
				subheading={friend.source ? friend.source : null}
			/>
		</div>
	)
}

function Participants({ planImg, users }) {
	const accepted = []
	const invited = []
	// build accepted and not accepted lists
	users.forEach((user) => {
		if (user.status === 'accepted' || user.status === 'host') accepted.push(user)
		if (user.status === 'invited') invited.push(user)
	})

	return (
		<div className='pwf-flow pwf-invite'>
			<div className='reading_plan_index_header columns medium-8 small-12 small-centered'>
				<div className='row text-center' style={{ fontSize: '18px' }}>
					Participants
				</div>
			</div>
			<div className='gray-background content'>
				<div className='columns medium-5 small-12 small-centered white' style={{ paddingTop: '1.07143rem', paddingBottom: '1.07143rem' }}>
					<div className='horizontal-center' style={{ height: '250px', marginBottom: '30px' }}>
						<LazyImage
							alt='plan-image'
							src={planImg}
							width={400}
							height={250}
							placeholder={<img alt='plan' src={PLAN_DEFAULT} />}
						/>
					</div>
					<div className='users'>
						<CustomScroll>
							{
								!users ?
									<div>Loading...</div> :
									<div>
										<div className='friend-list' style={{ marginBottom: '30px' }}>
											{
												accepted.length > 0 &&
												<div className='gray-heading'>
													Accepted ({ accepted.length })
												</div>
											}
											{
												accepted.map((user) => {
													return renderUser(user)
												})
											}
										</div>
										<div className='friend-list'>
											{
												invited.length > 0 &&
												<div className='gray-heading'>
													Not Accepted ({ invited.length })
												</div>
											}
											{
												invited.map((user) => {
													return renderUser(user)
												})
											}
										</div>
									</div>
							}
						</CustomScroll>
					</div>
				</div>
			</div>
		</div>
	)
}

Participants.propTypes = {
	planImg: PropTypes.string,
	users: PropTypes.array,
}

export default Participants
