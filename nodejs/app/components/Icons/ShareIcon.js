import React, { PropTypes } from 'react'

function ShareIcon({ width, height, fill }) {
	return (
		<div className="shareicon-container vertical-center">
			<svg className='shareicon' viewBox="0 0 24 33" width={width} height={height} version="1.1" xmlns="http://www.w3.org/2000/svg" xlink="http://www.w3.org/1999/xlink">
				<g stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
					<g transform="translate(-942.000000, -1335.000000)" fill={fill}>
						<g transform="translate(460.000000, 1236.000000)">
							<path d="M493,102.390617 L489.730497,105.66012 C489.340931,106.049685 488.711266,106.051631 488.318019,105.658384 C487.927495,105.267859 487.926503,104.635687 488.316283,104.245906 L493.269503,99.2926865 C493.475491,99.0866987 493.748608,98.9890858 494.018408,99.0009671 C494.27603,98.9990515 494.534049,99.0962384 494.730497,99.2926865 L499.683717,104.245906 C500.073282,104.635472 500.075227,105.265137 499.681981,105.658384 C499.291456,106.048908 498.659284,106.049901 498.269503,105.66012 L494.991074,102.381691 L494.861841,120.377482 L493,120.529843 L493,102.390617 Z M484.016903,110.437454 L484.016903,129.493799 L504.072392,129.493799 L504.072392,110.437454 L497.064616,110.437454 L497.064616,108.469994 L506,108.469994 L506,131.451623 L482,131.451623 L482,108.469994 L485.658006,108.469994 L490.961458,108.469994 L490.961458,110.437454 L484.016903,110.437454 Z" />
						</g>
					</g>
				</g>
			</svg>
		</div>
	)
}


ShareIcon.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
}

ShareIcon.defaultProps = {
	width: 15,
	height: 20,
	fill: '#000000',
}

export default ShareIcon
