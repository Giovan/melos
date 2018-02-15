import React from 'react'
import PropTypes from 'prop-types'
import selectImageFromList from '@youversion/utils/lib/images/selectImageFromList'
import PlanNavigation from './PlanNavigation'

function PlanReader(props) {
	const {
		plan,
		day,
		contentNum,
		totalSegments,
		previousPath,
		nextPath,
		subLink,
		showCheckmark,
		handleContentCheck,
		isRtl,
		updateStyle,
		customClass,
		children
	} = props

	return (
		<div>
			<PlanNavigation
				planName={plan && plan.name ? plan.name.default : null}
				planImgUrl={plan && plan.images ?
					selectImageFromList({
						images: plan.images,
						width: 320,
						height: 320
					}).url :
					null
				}
				day={day}
				previous={previousPath}
				next={nextPath}
				subLink={subLink}
				contentNum={contentNum}
				totalSegments={totalSegments}
				showCheckmark={showCheckmark}
				onHandleComplete={handleContentCheck}
				isRtl={isRtl()}
				// if we're rendering the full chapter from button click, let's
				// update the arrow positioning
				updateStyle={updateStyle}
			/>
			<div className={`plan-reader-content ${customClass}`}>
				<div className='large-6 medium-8 small-11 centered'>
					{ children }
				</div>
			</div>
		</div>
	)
}

PlanReader.propTypes = {
	plan: PropTypes.object.isRequired,
	children: PropTypes.node.isRequired,
	customClass: PropTypes.string,
	day: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
	contentNum: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
	totalSegments: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
	previousPath: PropTypes.string,
	nextPath: PropTypes.string,
	subLink: PropTypes.string,
	showCheckmark: PropTypes.bool,
	handleContentCheck: PropTypes.func,
	isRtl: PropTypes.func,
	updateStyle: PropTypes.bool,
}

PlanReader.defaultProps = {
	showFullChapter: false,
	customClass: '',
	day: null,
	contentNum: null,
	totalSegments: null,
	previousPath: null,
	nextPath: null,
	subLink: null,
	showCheckmark: false,
	handleContentCheck: null,
	isRtl: null,
	updateStyle: null,
}

export default PlanReader
