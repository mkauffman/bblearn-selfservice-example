function check_field(x) {
		if (x=='delete')
			{
				document.getElementById('confirm_btn').disabled = false
			} else {
				document.getElementById('confirm_btn').disabled = true
			}
	} // function check_field(x)
	
function check_length(x){
	if (x.length > 1000) 
	{
		document.getElementById('add_button').disabled = true
	} else {
		document.getElementById('add_button').disabled = false
	}
} // function check_length(x)