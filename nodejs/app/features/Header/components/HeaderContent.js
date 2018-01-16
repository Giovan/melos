import React, { PropTypes, Component } from 'react'
import { FormattedMessage } from 'react-intl'
import friendshipsAction from '@youversion/api-redux/lib/endpoints/friendships/action'
import notificationsAction from '@youversion/api-redux/lib/endpoints/notifications/action'
import usersAction from '@youversion/api-redux/lib/endpoints/users/action'
import localizedLink from '@youversion/utils/lib/routes/localizedLink'
import SectionedLayout from '../../../components/SectionedLayout'
import IconButtonGroup from '../../../components/IconButtonGroup'
import IconButton from '../../../components/IconButton'
import Button from '../../../components/Button'
import ButtonGroup from '../../../components/ButtonGroup'
import NoticeIcon from '../../../components/NoticeIcon'
import DropdownTransition from '../../../components/DropdownTransition'
import Home from '../../../components/icons/Home'
import Read from '../../../components/icons/Read'
import Plans from '../../../components/icons/Plans'
import Videos from '../../../components/icons/Videos'
import Friends from '../../../components/icons/Friends'
import More from '../../../components/icons/More'
import Notifications from '../../../components/icons/Notifications'
import Settings from '../../../components/icons/Settings'
import Avatar from '../../../components/Avatar'
import ProfileMenu from './ProfileMenu'
import NotificationsInbox from '../../Notifications/components/NotificationsInbox'
import Search from '../../../components/Search'
import StickyHeader from '../../../components/StickyHeader'
import { ScreenSize } from '../../../lib/responsiveConstants'

class HeaderContent extends Component {
	constructor(props) {
		super(props)
		this.state = {
			isLoggedIn: false,
			userId: null,
			ready: false,
			profileMenuOpen: false,
			notificationsOpen: false
		}
	}

	componentDidMount() {
		const { dispatch, loggedInUser } = this.props

		if (typeof loggedInUser === 'object' && 'userid' in loggedInUser) {
			const userId = loggedInUser.userid
			this.setState({ isLoggedIn: true, userId })
			dispatch(friendshipsAction({ method: 'incoming', params: { page: 1 }, auth: true }))
			dispatch(notificationsAction({ method: 'items', auth: true }))
			dispatch(usersAction({ method: 'view', params: { id: userId } })).then(() => {
				this.setState({ ready: true })
			})
		} else {
			setTimeout(() => {
				this.setState({ ready: true, isLoggedIn: false, userId: null })
			}, 300)
		}
	}

	componentWillReceiveProps(nextProps) {
		const { notifications: nextNotifications, friendshipRequests: nextFriendshipRequests } = nextProps
		const { notifications, friendshipRequests } = this.props

		if (nextNotifications && nextNotifications !== notifications) {
			let hasNotifications = false
			if ('items' in nextNotifications && nextNotifications.new_count > 0) {
				hasNotifications = true
			}
			this.setState({ hasNotifications })
		}

		if (nextFriendshipRequests && nextFriendshipRequests !== friendshipRequests) {
			let hasFriendshipRequests = false
			if ('users' in nextFriendshipRequests && Array.isArray(nextFriendshipRequests.users) && nextFriendshipRequests.users.length > 0) {
				hasFriendshipRequests = true
			}
			this.setState({ hasFriendshipRequests })
		}
	}

	handleProfileMenuClick = () => {
		this.setState((state) => {
			return { profileMenuOpen: !state.profileMenuOpen }
		})
	}

	handleProfileMenuClose = () => {
		this.setState({ profileMenuOpen: false })
	}

	handleSearch = (searchQuery) => {
		const { serverLanguageTag } = this.props
		let searchTarget = 'bible'
		if (window.location.pathname.indexOf('/reading-plans') > -1) {
			searchTarget = 'plans'
		} else if (window.location.pathname.indexOf('/users') > -1) {
			searchTarget = 'users'
		}
		window.location = localizedLink(`/search/${searchTarget}?q=${encodeURIComponent(searchQuery)}`, serverLanguageTag)
	}

	handleNotificationsClick = () => {
		const { dispatch } = this.props
		this.setState((state) => {
			if (!state.notificationsOpen) {
				dispatch(notificationsAction({ method: 'update', auth: true }))
			}
			// close profile menu when notifications are opened on mobile
			return {
				notificationsOpen: !state.notificationsOpen,
				profileMenuOpen: state.profileMenuOpen
					? !state.profileMenuOpen
					: state.profileMenuOpen
			}
		})
	}

	render() {
		const {
			serverLanguageTag,
			user,
			loggedInUser,
			screenSize
		} = this.props

		const {
			hasNotifications,
			hasFriendshipRequests,
			isLoggedIn,
			ready,
			profileMenuOpen,
			notificationsOpen
		} = this.state

		const plansButton = (
			<IconButton label={<FormattedMessage id="header.plans" />} useClientRouting={false} to={localizedLink('/reading-plans', serverLanguageTag)}>
				<Plans />
			</IconButton>
		)

		const videosButton = (
			<IconButton label={<FormattedMessage id="header.videos" />} useClientRouting={false} to={localizedLink('/videos', serverLanguageTag)}>
				<Videos />
			</IconButton>
		)

		const search = (
			<Search
				placeholder="Search..."
				showClear={false}
				showClose={screenSize === ScreenSize.SMALL}
				showInput={screenSize > ScreenSize.SMALL}
				onHandleSearch={this.handleSearch}
			/>
		)

		const homeLink = isLoggedIn ? '/moments' : '/'
		const left = (
			<div>
				<IconButtonGroup iconHeight={24} iconSpacing={44} >
					<IconButton label={<FormattedMessage id="header.home" />} useClientRouting={false} to={localizedLink(homeLink, serverLanguageTag)}>
						<Home />
					</IconButton>
					<IconButton label={<FormattedMessage id="header.read" />} useClientRouting={false} to={localizedLink('/bible', serverLanguageTag)}>
						<Read />
					</IconButton>
					{ (screenSize > ScreenSize.MEDIUM) ? plansButton : null }
					{ (screenSize > ScreenSize.MEDIUM) ? videosButton : null }
				</IconButtonGroup>
			</div>
		)

		const profileTopContent = (screenSize < ScreenSize.LARGE)
			? (<div>
				<IconButtonGroup iconHeight={24} iconSpacing={44}>
					{plansButton}
					{videosButton}
				</IconButtonGroup>
			</div>)
			: null

		const userNotificationGroup = isLoggedIn ? (
			<IconButtonGroup iconHeight={24} iconSpacing={24} verticalAlign="middle">
				<IconButton to={null} className='notification-button' useClientRouting={false} onClick={this.handleNotificationsClick}>
					<NoticeIcon showNotice={hasNotifications}>
						<Notifications />
					</NoticeIcon>
				</IconButton>
				<IconButton to={localizedLink('/friends', serverLanguageTag)} useClientRouting={false}>
					<NoticeIcon showNotice={hasFriendshipRequests}>
						<Friends />
					</NoticeIcon>
				</IconButton>
				<IconButton to={localizedLink('/settings', serverLanguageTag)} useClientRouting={false}>
					<Settings />
				</IconButton>
				{(screenSize > ScreenSize.MEDIUM) && ('response' in user) &&
					<IconButton lockHeight={true} onClick={this.handleProfileMenuClick} useClientRouting={false}>
						<Avatar
							customClass="yv-profile-menu-trigger"
							placeholderText={
								loggedInUser
									&& loggedInUser.first_name
									&& loggedInUser.first_name[0]
									&& loggedInUser.first_name[0].toUpperCase()
							}
							width={36}
							height={36}
							src={user.response.has_avatar && user.response.user_avatar_url.px_48x48}
						/>
					</IconButton>
				}
			</IconButtonGroup>
		) : null

		const moreMenu = screenSize < ScreenSize.LARGE ? (
			<IconButtonGroup iconHeight={24} iconSpacing={24} verticalAlign="middle">
				<IconButton className="yv-profile-menu-trigger" onClick={this.handleProfileMenuClick} useClientRouting={false}>
					<More />
				</IconButton>
			</IconButtonGroup>
		) : null

		const signUpButtons = !isLoggedIn && (
			<ButtonGroup buttonWidth={100}>
				<Button to={localizedLink('/sign-in')} useClientRouting={false}><FormattedMessage id="header.sign in" /></Button>
				<Button to={localizedLink('/sign-up')} useClientRouting={false}><FormattedMessage id="header.sign up" /></Button>
			</ButtonGroup>
		)

		const right = isLoggedIn
		? (
			<div className={`yv-header-right ${ready && 'ready'}`}>
				{screenSize < ScreenSize.LARGE && search}
				{(screenSize > ScreenSize.MEDIUM) ? userNotificationGroup : moreMenu}
				{
					<DropdownTransition
						show={notificationsOpen}
						hideDir="up"
						transition={true}
						onOutsideClick={() => { this.setState({ notificationsOpen: false }) }}
						containerClasses="yv-profile-menu-container"
						exemptClass="notification-button"
					>
						<NotificationsInbox />
					</DropdownTransition>
				}
				{
					('response' in user) &&
					<DropdownTransition
						show={profileMenuOpen}
						hideDir="up"
						transition={true}
						onOutsideClick={this.handleProfileMenuClose}
						exemptClass="yv-profile-menu-trigger"
						classes="yv-popup-modal-content"
						containerClasses="yv-profile-menu-container"
					>
						<ProfileMenu
							username={user.response.username}
							firstName={user.response.first_name}
							lastName={user.response.last_name}
							avatarUrl={user.response.user_avatar_url.px_48x48}
							serverLanguageTag={serverLanguageTag}
							topContent={profileTopContent}
							topAvatarContent={(screenSize < ScreenSize.LARGE) ? userNotificationGroup : null}
						/>
					</DropdownTransition>
				}
			</div>
		)
		: (
			<div className={`yv-header-right ${ready && 'ready'}`}>
				{screenSize < ScreenSize.LARGE && search}
				{(screenSize > ScreenSize.MEDIUM) ? signUpButtons : moreMenu}
				<DropdownTransition
					show={profileMenuOpen}
					hideDir="up"
					transition={true}
					onOutsideClick={this.handleProfileMenuClose}
					exemptClass="yv-profile-menu-trigger"
					classes="yv-popup-modal-content"
					containerClasses="yv-profile-menu-container"
				>
					<ProfileMenu
						serverLanguageTag={serverLanguageTag}
						topContent={profileTopContent}
						bottomContent={signUpButtons}
					/>
				</DropdownTransition>
			</div>
		)

		return (
			<StickyHeader className="yv-header">
				<SectionedLayout
					left={left}
					right={right}
				>
					<div>
						{screenSize > ScreenSize.MEDIUM && search}
					</div>
				</SectionedLayout>
			</StickyHeader>
		)
	}
}


HeaderContent.propTypes = {
	serverLanguageTag: PropTypes.string,
	dispatch: PropTypes.func.isRequired,
	loggedInUser: PropTypes.object,
	notifications: PropTypes.object,
	friendshipRequests: PropTypes.object,
	user: PropTypes.object,
	screenSize: PropTypes.number
}

HeaderContent.defaultProps = {
	serverLanguageTag: 'en',
	loggedInUser: null,
	notifications: null,
	friendshipRequests: null,
	user: null,
	screenSize: ScreenSize.SMALL
}

export default HeaderContent
