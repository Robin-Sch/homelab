const jelly_api = "https://XXXX";
const jelly_api_key = "XXXX"

const fancyTimeFormat = (duration) => {
  // Hours, minutes and seconds
  const hrs = ~~(duration / 3600);
  const mins = ~~((duration % 3600) / 60);
  const secs = ~~duration % 60;

  // Output like "1:01" or "4:03:59" or "123:03:59"
  let ret = "";

  if (hrs > 0) {
    ret += "" + hrs + ":" + (mins < 10 ? "0" : "");
  }

  ret += "" + mins + ":" + (secs < 10 ? "0" : "");
  ret += "" + secs;

  return ret;
}

const music = () => {
	fetch(`${jelly_api}/Sessions?ActiveWithinSeconds=60&api_key=${jelly_api_key}`)
	.then((res) => { return res.json() })
	.then((data) => {
		const el = document.getElementById("music-details");
		if (!data[0]) { return el.innerHTML = "Nothing is playing" }

		const paused = data[0].PlayState.IsPaused;
		if (paused) { return el.innerHTML = "Nothing is playing" }
		else {
			const name = data[0].NowPlayingItem.Name;
			const artists = data[0].NowPlayingItem.Artists;

			const length_ticks = data[0].NowPlayingItem.RunTimeTicks;
			const length_seconds = length_ticks / 10000000;
			const length_pretty = fancyTimeFormat(length_seconds);

			const at_ticks = data[0].PlayState.PositionTicks;
			const at_seconds = at_ticks / 10000000;
			const at_pretty = fancyTimeFormat(at_seconds);

			return el.innerHTML = `${name} - ${artists} (${at_pretty}/${length_pretty})`;
		}
	});

	setTimeout(music, 1000 * 10);
}

music();