import React, { PropTypes } from 'react'
import getProportionalSize from '../../lib/imageProportions'

function Notifications({ width, height, fill, className }) {
	const {
		height: finalHeight,
		width: finalWidth
	} = getProportionalSize({
		defaultHeight: Notifications.defaultProps.height,
		defaultWidth: Notifications.defaultProps.width,
		newHeight: height,
		newWidth: width
	})

	return (
		<svg
			className={className}
			width={finalWidth}
			height={finalHeight}
			viewBox="0 0 24 24"
			version="1.1"
			xmlns="http://www.w3.org/2000/svg"
		>
			<g fill="none" fillRule="evenodd">
				<path d="M0 0h24v24H0z" />
				<g fill={fill} fillRule="nonzero">
					<path
						d="M19.168 16.832v-.729a1.126 1.126 0 0 0-.347-.75s-1.978-2.536-2.201-6.564c-.27-4.827-3.736-4.63-5.016-4.63-1.28 0-4.745-.197-5.014 4.627-.223 4.033-2.203 6.563-2.203 6.563-.207.197-.331.466-.347.75v.733c0 .251.204.455.456.456h14.216a.463.463 0 0 0 .456-.456zM9.789 18.192c0 .832.68 1.808 1.512 1.808h.606c.831 0 1.512-.976 1.512-1.808H9.79z"
					/>
				</g>
			</g>
		</svg>
	)
}

Notifications.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
	className: PropTypes.string
}

Notifications.defaultProps = {
	width: 24,
	height: 24,
	fill: '#444444',
	className: ''
}

export default Notifications
