import React, { PropTypes, Component } from 'react'
import Immutable from 'immutable'
import { connect } from 'react-redux'
import { routeActions } from 'react-router-redux'
import { Link } from 'react-router'
import { FormattedMessage } from 'react-intl'
import planView from '@youversion/api-redux/lib/batchedActions/planView'
import plansAPI from '@youversion/api-redux/lib/endpoints/plans'
import { getParticipantsUsersByTogetherId } from '@youversion/api-redux/lib/models'
import getTogetherModel from '@youversion/api-redux/lib/models/together'
import getSubscriptionsModel from '@youversion/api-redux/lib/models/subscriptions'
import { getPlanById } from '@youversion/api-redux/lib/endpoints/readingPlans/reducer'
import { selectImageFromList } from '../lib/imageUtil'
import Routes from '../lib/routes'
import Participants from '../features/PlanDiscovery/components/Participants'
import Modal from '../components/Modal'
import ConfirmationDialog from '../components/ConfirmationDialog'
import User from '../components/User'


class ParticipantsView extends Component {
	constructor(props) {
		super(props)
		this.state = {
			userToDelete: null
		}
	}

	componentDidMount() {
		const {
			dispatch,
			auth,
			params: { id, together_id },
			location: { query },
			plan,
			participantsUsers,
			together,
		} = this.props

		// join token will allow us to see the participants and together unauthed
		const token = query && query.token ? query.token : null
		if (!(plan && 'id' in plan && participantsUsers)) {
			dispatch(planView({
				plan_id: id.split('-')[0],
				together_id,
				token,
				auth,
			}))
		}
		if (!(together && 'id' in together)) {
			dispatch(plansAPI.actions.together.get({
				id: together_id,
				token
			}, { auth: auth && auth.isLoggedIn }))
		}
	}

	localizedLink = (link) => {
		const { params, serverLanguageTag } = this.props
		const languageTag = serverLanguageTag || params.lang || 'en'

		if (['en', 'en-US'].indexOf(languageTag) > -1) {
			return link
		} else {
			return `/${languageTag}${link}`
		}
	}

	deleteParticipant = () => {
		const { dispatch, auth, params: { together_id }, subscriptions } = this.props
		const { userToDelete } = this.state
		dispatch(plansAPI.actions.participant.delete(
			{
				id: together_id,
				userid: userToDelete,
			}, {
				auth: true,
			}
		)).then(() => {
			// remove subscription from state for authed user
			this.modal.handleClose()
			if (auth.userData.userid === userToDelete) {
				let idToDelete
				Object.keys(subscriptions.byId).forEach((id) => {
					const sub = subscriptions.byId[id]
					if (parseInt(sub.together_id, 10) === parseInt(together_id, 10)) {
						idToDelete = id
					}
				})
				dispatch({ type: 'DELETE_SUB_FROM_STATE', data: { id: idToDelete } })
				dispatch(routeActions.push(Routes.subscriptions({
					username: auth.userData.username
				})))
			}
		})
	}

	openDelete = (userid) => {
		this.setState({ userToDelete: userid })
		this.modal.handleOpen()
	}

	render() {
		const { plan, participantsUsers, together, auth, location: { query } } = this.props
		const { userToDelete } = this.state

		const day = query && query.day ? parseInt(query.day, 10) : null
		let userList = null
		if (participantsUsers) {
			userList = Object.keys(participantsUsers).map((userid) => {
				const user = participantsUsers[userid]
				return user
			})
		}
		const deleteUserData = participantsUsers
			&& userToDelete
			&& participantsUsers[userToDelete]
		const src = plan && plan.images ? selectImageFromList({ images: plan.images, width: 640, height: 320 }).url : ''
		this.isAuthHost = together
			&& together.host_user_id
			&& auth
			&& Immutable
					.fromJS(auth)
					.getIn(['userData', 'userid'], null) === together.host_user_id
		const backLink = (
			auth.isLoggedIn
				? (
					<Link to={Routes.subscriptions({ username: auth.userData.username })} className='yv-gray-link'>
						<FormattedMessage id='plans.my_plans' />
					</Link>
				)
				: (
					<Link to={Routes.plan({ plan_id: plan && plan.id })} className='yv-gray-link'>
						<FormattedMessage id='plans.about this plan' />
					</Link>
				)
		)

		return (
			<div>
				<Participants
					planImg={src}
					users={userList}
					shareLink={together && together.public_share ? together.public_share : null}
					// only allow participant deletes if the authed user is the host of pwf
					handleDelete={this.isAuthHost && this.openDelete}
					// show checkmarks if we have a specific day
					activities={
						together
						&& together.activities
						&& day
						&& Immutable
								.fromJS(together)
								.getIn(['activities', `${day}`, 'data'])
								.toJS()
					}
					backLink={backLink}
				/>
				<Modal
					ref={(ref) => { this.modal = ref }}
					handleCloseCallback={() => {
						this.setState({ userToDelete: null })
					}}
					customClass='large-3 medium-6 small-10'
				>
					<ConfirmationDialog
						handleConfirm={this.deleteParticipant}
						handleCancel={() => { this.modal.handleClose() }}
						subPrompt={
							deleteUserData &&
							'id' in deleteUserData &&
							<User
								avatarLetter={deleteUserData.first_name ? deleteUserData.first_name.charAt(0) : null}
								src={deleteUserData.user_avatar_url.px_48x48}
								width={26}
								heading={deleteUserData.name ? deleteUserData.name : null}
								subheading={deleteUserData.source ? deleteUserData.source : null}
							/>
						}
					/>
				</Modal>
			</div>
		)
	}
}


function mapStateToProps(state, props) {
	const { params: { id, together_id } } = props
	const plan_id = id ? id.split('-')[0] : null
	console.log('TOG', getTogetherModel(state))
	return {
		plan: getPlanById(state, plan_id),
		participantsUsers: getParticipantsUsersByTogetherId(state, together_id),
		together: getTogetherModel(state) && together_id in getTogetherModel(state).byId
			? getTogetherModel(state).byId[together_id]
			: null,
		subscriptions: getSubscriptionsModel(state),
		auth: state.auth,
		serverLanguageTag: state.serverLanguageTag,
	}
}

ParticipantsView.propTypes = {
	plan: PropTypes.object.isRequired,
	together: PropTypes.object.isRequired,
	auth: PropTypes.object.isRequired,
	params: PropTypes.object.isRequired,
	participantsUsers: PropTypes.object.isRequired,
	serverLanguageTag: PropTypes.string.isRequired,
	dispatch: PropTypes.func.isRequired,
}

export default connect(mapStateToProps, null)(ParticipantsView)
