import React from 'react'
import PropTypes from 'prop-types'
import getProportionalSize from '@youversion/utils/lib/images/imageProportions'

function InstagramLogo({ width, height, fill, className }) {
	const {
		height: finalHeight,
		width: finalWidth
	} = getProportionalSize({
		defaultHeight: InstagramLogo.defaultProps.height,
		defaultWidth: InstagramLogo.defaultProps.width,
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
			<g stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
				<g transform="translate(-806.000000, -107.000000)" fill={fill}>
					<g transform="translate(490.000000, 62.000000)">
						<g transform="translate(29.000000, 44.000000)">
							<path d="M298.962476,3.16220593 C302.156617,3.16220593 302.534932,3.17440026 303.796329,3.23213276 C304.962661,3.28553055 305.596066,3.4810208 306.01764,3.64531072 C306.575971,3.86299845 306.974515,4.1230805 307.393097,4.54297487 C307.811679,4.96286924 308.070948,5.36266203 308.287908,5.92274348 C308.451732,6.3456388 308.646612,6.98102973 308.699843,8.15097025 C308.757395,9.41636945 308.769551,9.79587013 308.769551,13.0000238 C308.769551,16.2041775 308.757395,16.5836782 308.699843,17.8490298 C308.646612,19.0190179 308.451732,19.6544088 308.287908,20.0773041 C308.070948,20.6373856 307.811679,21.0371784 307.393097,21.4570728 C306.974515,21.8769671 306.575971,22.1370492 306.01764,22.3546893 C305.596066,22.5190268 304.962661,22.7145171 303.796329,22.7679149 C302.535122,22.8256474 302.156807,22.8378417 298.962476,22.8378417 C295.768146,22.8378417 295.389831,22.8256474 294.128623,22.7679149 C292.962292,22.7145171 292.328886,22.5190268 291.90736,22.3546893 C291.348981,22.1370492 290.950438,21.8769671 290.531856,21.4570728 C290.113273,21.0371784 289.854004,20.6373856 289.637044,20.0773041 C289.47322,19.6544088 289.278341,19.0190179 289.22511,17.8490774 C289.167558,16.5836782 289.155402,16.2041775 289.155402,13.0000238 C289.155402,9.79587013 289.167558,9.41636945 289.22511,8.15101788 C289.278341,6.98102973 289.47322,6.3456388 289.637044,5.92274348 C289.854004,5.36266203 290.113273,4.96286924 290.531856,4.54297487 C290.950438,4.1230805 291.348981,3.86299845 291.90736,3.64531072 C292.328886,3.4810208 292.962292,3.28553055 294.128576,3.23213276 C295.390021,3.17440026 295.768336,3.16220593 298.962476,3.16220593 M298.962476,1 C302.21132,1 302.618696,1.01381388 303.894576,1.07221326 C305.167892,1.13051737 306.037441,1.33334326 306.798392,1.63000828 C307.585032,1.93667645 308.252152,2.34699637 308.917183,3.01411159 C309.582213,3.68122682 309.991251,4.35043794 310.29696,5.13954402 C310.592698,5.90288008 310.794891,6.77515526 310.853012,8.05246298 C310.911229,9.33234294 310.925,9.74099567 310.925,13.0000238 C310.925,16.259052 310.911229,16.6677047 310.853012,17.9475847 C310.794891,19.2248924 310.592698,20.0971676 310.29696,20.8605036 C309.991251,21.6496097 309.582213,22.3188208 308.917183,22.985936 C308.252152,23.6530513 307.585032,24.0633712 306.798392,24.3700394 C306.037441,24.6667044 305.167892,24.8695303 303.894576,24.9278344 C302.618696,24.9862338 302.21132,25 298.962476,25 C295.713633,25 295.306304,24.9862338 294.030377,24.9278344 C292.75706,24.8695303 291.887511,24.6667044 291.12656,24.3700394 C290.33992,24.0633712 289.6728,23.6530513 289.00777,22.985936 C288.34274,22.3188208 287.933702,21.6495621 287.627992,20.8605036 C287.332254,20.0971676 287.130062,19.2248924 287.07194,17.9475847 C287.013723,16.6677047 287,16.259052 287,13.0000238 C287,9.74099567 287.013723,9.33234294 287.07194,8.05246298 C287.130062,6.77515526 287.332254,5.90288008 287.627992,5.13954402 C287.933702,4.35043794 288.34274,3.68122682 289.00777,3.01411159 C289.6728,2.34699637 290.33992,1.93667645 291.12656,1.63000828 C291.887511,1.33334326 292.75706,1.13051737 294.030377,1.07221326 C295.306304,1.01381388 295.713633,1 298.962476,1 Z M298.962476,6.8378417 C295.569847,6.8378417 292.819551,9.59675969 292.819551,13.0000238 C292.819551,16.4032879 295.569847,19.1622059 298.962476,19.1622059 C302.355105,19.1622059 305.105402,16.4032879 305.105402,13.0000238 C305.105402,9.59675969 302.355105,6.8378417 298.962476,6.8378417 Z M298.962476,17.0000476 C296.760254,17.0000476 294.974953,15.2091493 294.974953,13.0000238 C294.974953,10.7908983 296.760254,9 298.962476,9 C301.164698,9 302.95,10.7908983 302.95,13.0000238 C302.95,15.2091493 301.164698,17.0000476 298.962476,17.0000476 Z M306.783577,6.59438394 C306.783577,5.79908543 306.140912,5.15440585 305.348099,5.15440585 C304.555285,5.15440585 303.912573,5.79908543 303.912573,6.59438394 C303.912573,7.38968246 304.555285,8.03440966 305.348099,8.03440966 C306.140912,8.03440966 306.783577,7.38968246 306.783577,6.59438394 Z" />
						</g>
					</g>
				</g>
			</g>
		</svg>
	)
}

InstagramLogo.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
	className: PropTypes.string
}

InstagramLogo.defaultProps = {
	width: 24,
	height: 24,
	fill: '#444444',
	className: ''
}

export default InstagramLogo
