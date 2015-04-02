/**
 * last.fm methods caller instance
 * 
 * @type Object 
 */
var lastFmCaller = {
	
	API_KEY: 'cfe10fbc56a2dc5583a0c9209148a745',
	SERVICE_URL: 'http://ws.audioscrobbler.com/2.0/',
	
	TEMP_STORE_VAR_SPEC: 'lastFmCaller.__tempStore',
	ID_HANDLER_SPEC: 'lastFmCaller.__callIdHandler',
	RESULT_HANDLER_SPEC: 'lastFmCaller.__callResultHandler',
	
	_callsDataStore: [],
	_callsCounter: 0,
	
	__tempStore: [], // always 1 null element with index 0
	__lastIdReceived: null,
	
	/**
	 * call last.fm method by name, with callback function and a possibility to
	 * pass some data
	 * 
	 * @param {String} methodName name of the method to call in the form 
	 *                            'library.getArtists'
	 * @param {Object} paramsObj method parameters as an object, like:
	 *                           { user: 'username', page: 2 }
	 * @param {Function(Object, Object)} [callbackFunc] callback function, which 
	 *                                   receives a result and an additional
	 *                                   data, passed in (additionalData)
	 * @param {Object} [additionalData] any additional data to pass to the callback
	 */
	callMethod: function(methodName, paramsObj, callbackFunc, additionalData) {
        var paramsString = 'method=' + methodName + 
                          '&api_key=' + this.API_KEY + 
                          '&format=' + 'json' + 
                          '&callback=' + this.TEMP_STORE_VAR_SPEC +                                         
                                       '[' + this.ID_HANDLER_SPEC + '(' +
                                            this._callsCounter + 
                                       ')]=' + this.RESULT_HANDLER_SPEC;
        // The trick is done because I can not pass ';' symbols through URL in 
        // any format, and I can't just call the function before to store the id.
        // (no data can be transferred to/from last.fm to identify the request
        // that was just performed).                               
        // So the result script will be equal to (lfc is lastFmCaller):
        // 'lfc.__tempStore[lfc.__callIdHandler(<id>)]=lfc.__callResultHandler(<json_object>);'
        // __callIdHandler will be called first and register the last id,
        // and will return 0, and then __callResultHandler will immediately get 
        // the result and get the id as the last registered, and the null will 
        // be returned. so it will be always 'lfc.__tempStore[0] = null;' after 
        // functions call. 
        for (paramName in paramsObj) {
            paramsString += '&' + paramName + '=' + paramsObj[paramName];
        }
        
        var scriptElm = document.createElement('script');
        scriptElm.type = 'text/javascript';
        scriptElm.src = 'http://ws.audioscrobbler.com/2.0/' + '?' + paramsString;
		
		this._callsDataStore[this._callsCounter] = {
			callback: callbackFunc,
			script: scriptElm,
			data: additionalData 
		}
		
		
		// TODO: make a 300ms pause
        document.body.appendChild(scriptElm);
		this._callsCounter++;				
	},
	
	__callResultHandler: function(result) {
		var curStore = this._callsDataStore[this.__lastIdReceived];
		//console.log(this.__lastIdReceived, result, this._callsDataStore[this.__lastIdReceived]);
		document.body.removeChild(curStore.script);
		if (curStore.callback) curStore.callback(result, curStore.data);
		this._callsDataStore[this.__lastIdReceived] = null;
        return null;
	},
	
	__callIdHandler: function(id) {
		this.__lastIdReceived = id;
		return 0;
	}

}