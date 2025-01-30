const owm_api = "https://api.openweathermap.org/data/2.5";
const owm_api_key = "XXXX"

const weather = () => {
	fetch(`${owm_api}/weather?appid=${owm_api_key}&q=XXXX&units=metric`)
	.then((res) => { return res.json() })
	.then((data) => {
		const description = data.weather[0].description;
		const temp = data.main.temp;
		const temp_feels = data.main.feels_like;
		const iconurl = `https://openweathermap.org/img/w/${data.weather[0].icon}.png`;

		document.getElementById("weather-details").innerHTML  = `${description}, ${temp} °C (FL: ${temp_feels} °C)`;
		document.getElementById("weather-icon").src = iconurl;
	});

	setTimeout(weather, 1000 * 60 * 10);
}

weather();