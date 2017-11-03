import moment from 'moment'

function calcTodayVsStartDt(start_dt) {
	const today = moment().startOf('day')
	const startDate = moment(start_dt, 'YYYY-MM-DD').startOf('day')
	const diff = today.diff(startDate, 'days')

	return {
		isInFuture: diff < 0,
		isInPast: diff > 0,
		isToday: diff === 0,
		string: `${moment().to(start_dt)} (${startDate.format('MMM D')})`
	}
}

export default calcTodayVsStartDt
