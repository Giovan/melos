import React, { PropTypes } from 'react'
import getProportionalSize from '../../lib/imageProportions'

function Read({ width, height, fill, className }) {
	const {
		height: finalHeight,
		width: finalWidth
	} = getProportionalSize({
		defaultHeight: Read.defaultProps.height,
		defaultWidth: Read.defaultProps.width,
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
			fillRule="evenodd"
		>
			<path
				fillRule="evenodd"
				stroke="none"
				fill={fill}
				d="M 18,18.5 L 18,19.49 18,19.49 C 18,20.04 17.55,20.49 17,20.49 17,20.49 17,20.49 17,20.49 10.14,20.47 6.68,20.45 6.63,20.45 4.88,20.33 4,19.35 4,17.5 4,12.59 4,10.9 4,6.42 4,4.45 5,3.5 7,3.5 L 19,3.5 19,3.5 C 19.55,3.5 20,3.95 20,4.5 L 20,17.5 C 20,18.05 19.55,18.5 19,18.5 L 18,18.5 Z M 18.47,4.5 L 8,4.5 C 6.81,4.5 6.14,4.83 6,5.5 L 17,5.5 17,5.5 C 17.55,5.5 18,5.95 18,6.5 L 18,17.5 18.5,17.5 18.5,17.5 C 18.77,17.5 19,17.27 19,17 L 19,17 18.97,5 C 18.97,4.72 18.74,4.5 18.47,4.5 L 18.47,4.5 Z M 18.47,4.5"
			/>
		</svg>
	)
}

Read.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
	className: PropTypes.string
}

Read.defaultProps = {
	width: 24,
	height: 24,
	fill: '#444444',
	className: ''
}

export default Read
