/**
 * Creates a reference to the instance method, so the returned value may be used
 * as a function, but in fact will be called as method of the concrete instance
 * @param {Object} object instance object
 * @param {String} methodName name of the method
 * @return {Function} a reference to the method 
 */
function createMethodReference(object, methodName) {
    return function () {
        return object[methodName].apply(object, arguments);
    };
}

/**
 * Get number of the object properties
 * 
 * @param {Object} obj object to count properties
 * @return {Integer} properties count
 */
function getPropsCount(obj) {
	if (obj.__count__) return obj.__count__;
	var count = 0;
    for (k in myobj) if (myobj.hasOwnProperty(k)) count++;
    return count;
}

/**
 * Creates a context holder to keep the search data relatively to the user
 * 
 * @param {String} username last.fm username
 */
function ArtistsContextHolder(username) { 
     
     this.username = username;
	
     this.prepare = function() {
        this.artists = [];
        this.currentPage = 0;
        this.totalPages = -1;
        this.error = null;
        this.gotPageFunc = null;
        this.gotResultFunc = null;     	
     }
     
     this.clear = function() {
         this.username = null;
         this.artists = null;
         this.currentPage = null;
         this.totalPages = null;
         this.error = null;
         this.gotPageFunc = null;
         this.gotResultFunc = null;
     }
     
     this.prepare();
}

// FIXME: remove console.log 
// FIXME: control, if there is no network
// TODO: all strings and id's to constants

/**
 * Creates a holder to keep the comparison data of the user
 * 
 * @param {String} username last.fm username
 */

function UserComparisonDataHolder(username) {
	
	this.username = username;
	
    this.prepare = function() {
       this.friends = [];
       this.artistsStats = null;
       this.percentages = null;
       this.statsLoadingInProgress = false;
    }
     
    this.clear = function() {
       this.username = null;
       this.friends = null;
       this.artistsStats = null;
       this.percentages = null;
       this.statsLoadingInProgress = null;
    }
	
	this.prepare();
}

var cc /* CompatibiltyCalculator */ = {
	
	USER_ARTISTS_METHOD_SPEC: 'library.getArtists',
	USER_FRIENDS_METHOD_SPEC:    'user.getFriends',

    _searchContextHolder: [],
    _comparisonDataHolder: [],
    
    _compareWithFriendsMode: false,
    _takeMismatchedMode: false,
    _firstUsername: '',
    _secondUsername: '',
    
    firstUsernameElm:  null,
    friendsListElm:    null,
    friendsStatusElm:  null,
    secondUsernameElm: null,
    mismatchesChkbElm: null,
    calculateBtnElm:   null,
    cancelProgressElm: null,
    userPgProgressElm: null,
    friendProgressElm: null,
    
    comparisonResultsElm: null,
    
    __friendsReceivingLock: false,
    __calculationCancelled: false,
    
    __friendsDataQueue: null,
    __friendsInProgressCount: null,
    __completedFriends: null,
    
    /* __percentageElmsHolder: {}, */
    
    __reportError:
        function(error) {
        	alert(error);  // TODO: error span
        	this.restoreAllElms();
        },
        
    __reportWarn:
        function(warn) {
        	alert(warn);  // TODO: warn span
        },

    _whenGotAllUserArtistsStats: 
        function(username, allArtists) {
           var contextHolder = this._searchContextHolder[username];
    	   //if (console) console.log(allArtists); else alert(allArtists);
           // console.log('got all: ' + allArtists.length);
           // alert('got all: ' + allArtists.length);
           if (contextHolder.gotResultFunc) 
                contextHolder.gotResultFunc(
                                allArtists, allArtists.length, contextHolder.totalPages); 
           this._searchContextHolder[username].clear();
           this._searchContextHolder[username] = null;
        },

    _gotArtistsPage: 
        function(root, callbackData) {
        	if (!this.__calculationCancelled) {
        		var contextHolder = this._searchContextHolder[callbackData.user];
            	if (root.error) {
            		this.__reportError('last.fm call error: ' + root.message);
                    if (contextHolder.gotPageFunc) 
                        contextHolder.gotPageFunc(
                                contextHolder.currentPage, contextHolder.totalPages, callbackData.user, true);            		
            		/* lastFmCaller.callMethod(this.USER_ARTISTS_METHOD_SPEC, 
                           { user: callbackData.user, page: contextHolder.currentPage }, 
                           callbackData.callback, callbackData); */ 
            		return;
            	}
            	
            	var artistsPage = root.artists;
            	if (artistsPage) {
                	var username = artistsPage.user;
                	// var contextHolder = this._searchContextHolder[username];
                	
                    for(artistIdx in artistsPage.artist) {
                        contextHolder.artists.push(artistsPage.artist[artistIdx]);
                    }
                    
                    contextHolder.currentPage = artistsPage.page;
                    contextHolder.totalPages  = artistsPage.totalPages;
                    
                    // console.log('got page ' + contextHolder.currentPage);
                    
                   if (contextHolder.gotPageFunc) 
                        contextHolder.gotPageFunc(
                                contextHolder.currentPage, contextHolder.totalPages, username, false);            
                    
                    if (parseInt(artistsPage.page) == parseInt(artistsPage.totalPages)) {
                       this._whenGotAllUserArtistsStats(username, contextHolder.artists);
                    } else {                
                        lastFmCaller.callMethod(this.USER_ARTISTS_METHOD_SPEC, 
                           { user: username, page: parseInt(contextHolder.currentPage) + 1 }, 
                           callbackData.callback, callbackData); 
                    }
            	} else {
            		// console.log('WARN: artists load for ' + callbackData.user + ' failed from', root);
            		this.__reportWarn('WARN: artists load for ' + callbackData.user + ' failed from' + root);
            		if (contextHolder.gotPageFunc) 
                        contextHolder.gotPageFunc(
                                contextHolder.currentPage, contextHolder.totalPages, callbackData.user, true);
                    lastFmCaller.callMethod(this.USER_ARTISTS_METHOD_SPEC, 
                           { user: callbackData.user, page: contextHolder.currentPage }, 
                           callbackData.callback, callbackData);         		
            	}
        	} /* else {
        		this._whenGotAllUserArtistsStats(username, contextHolder.artists);
        	} */
        },
        
    _gotFriends:
        function(root, data) {
            if (root.error) {
                this.__reportError('last.fm call error: ' + root.message);
                data.errorfunc(root.error);
                return;
            }           
            data.callback(root.friends.user, data.user); // root.friends.for
        },
        
    getFriends: 
        function(username, gotFriendsFunc, errorHandleFunc) {
            lastFmCaller.callMethod(this.USER_FRIENDS_METHOD_SPEC, 
                          { user: username/*, recenttracks: false*/ }, 
                          createMethodReference(this, '_gotFriends'),
                          { user: username, 
                            callback: gotFriendsFunc, 
                            errorfunc: errorHandleFunc });
        },

    /**
     * Calls last.fm for user statistics by artist. Runs asynchronously.
     *   
     * @param {String} username user name to ask statistics for
     * @param {Function(Object, Integer, Integer)} [responseReceivedFunc] this 
     *                       function is called when all results are received:
     *                       (artistsObject, numOfArtists, totalPagesNum) 
     * @param {Function(Integer, Integer[, String])} [pageMonitorFunc] this function is 
     *                                     called for every page of statistics:
     *                                     (currentPageNum, totalPagesNum[, userName]) 
     */        
    askUserArtistsStats: 
        function(username, responseReceivedFunc, pageMonitorFunc) {
        	if (!this.__calculationCancelled) {
            	if (!this._searchContextHolder[username]) {
                                this._searchContextHolder[username] = 
                                                new ArtistsContextHolder(username);
            	}
            	
            	this._searchContextHolder[username].prepare();
            	var contextHolder = this._searchContextHolder[username];
            	// console.log('start');
            	contextHolder.currentPage = 1;
            	contextHolder.gotResultFunc = responseReceivedFunc;
            	contextHolder.gotPageFunc = pageMonitorFunc;
            	var methodRef = createMethodReference(this, '_gotArtistsPage');
            	lastFmCaller.callMethod(this.USER_ARTISTS_METHOD_SPEC, 
                              { user: username, page: 1 }, 
                              methodRef, {
                              	user: username,
                              	curPage: contextHolder.currentPage,
                                callback: methodRef
                              });
        	}
        },
        
    /**
     * Gets the artists statistics by song and calculates the percentage statistics
     * 
     * @param {Object} artistsStats artists statistics as returned by askUserArtistsStats
     * @return {Object{total,percentage}}
     * 
     * @see #askUserArtistsStats
     */
    getPercentageStats: 
        function(artistsStats) {
            var artistsPercentage = [];
            var totalCount = 0;
        	
    	    for (artistId in artistsStats) {
    	    	// console.log(totalCount + '+' + artistsStats[artistId].playcount + '=');
    	        totalCount += artistsStats[artistId].playcount ? parseInt(artistsStats[artistId].playcount) : 0;
    	        // console.log(totalCount);
    	    }
    	    
    	    var percentVal = (totalCount / 100);
    	    // console.log(percentVal);
            for (artistId in artistsStats) {
            	var artistData = artistsStats[artistId];
                artistsPercentage[artistData.name] = {
                    percent:   artistData.playcount ? (artistData.playcount / percentVal) : 0,
                    playcount: artistData.playcount ? artistData.playcount : 0
                }
                // console.log(artistsPercentage[artistData.name]);
            }
            
            // test percentage
            
            /* var totalPercentage = 0;
            for (artistName in artistsPercentage) {
            	totalPercentage += artistsPercentage[artistName].percent;
            }

            alert(totalPercentage + ';' + (totalPercentage == 100)) */
                        
            return {
            	total: totalCount,
            	percentage: artistsPercentage
            }
        },
    
    /**
     * Calculates compatibility, using the statistics. Runs synchronously.
     * Calls compatibilityCalculatedFunc (if specified) when completed and then returns 
     *         { matched: {Object[name]{left, right}} /matched artists list, if any/,
     *           mismatched: {Object[name]{left, right}} /mismatched artists list, if any/,
     *           compatibility: /compatibility result/
     *         }
     * 
     * @param {Object} leftPercentageStats statistics object for the first user,
     *                                     as returned by getPercentageStats
     * @param {Object} rightPercentageStats statistics object for the second user,
     *                                     as returned by getPercentageStats
     * @param {Boolean} considerTheMismatches do consider the mismatches when
     *                                     calculating
     * @param {Function(Float, Integer, Integer, Integer, Integer, Integer)} 
     *        [compatibilityCalculatedFunc] called when calculation is done and passes: 
     *                                    (computedResult, 
     *                                     matchedSongs,
     *                                     allSongsNum,
     *                                     artistsMatchedCount,
     *                                     artistsMisMatchedCount,
     *                                     artistsTotalNum);
     * @param {Function(String, Object{left,right})} [matchReactionFunc] called when 
     *                                     an artist match or mismatch found
     *                                     passes artist name and the left and right percentage
     * @return {Object{matched,[mismatched,]compatibility}} 
     *  
     * @see #getPercentageStats
     */
    calculateCompatibility:
        function(leftPercentageStats, rightPercentageStats, considerTheMismatches, compatibilityCalculatedFunc, matchReactionFunc) {
        	var leftPercentage = leftPercentageStats.percentage;
        	var rightPercentage = rightPercentageStats.percentage;
        	
        	var matchedArtists = {};
        	var mismatchedArtists = {};
        	var matchesCount = 0;
        	var mismatchesCount = 0;
        	
        	for (artistName in leftPercentage) {
        		if (rightPercentage[artistName]) {
        		    matchedArtists[artistName] = {
        		      left: leftPercentage[artistName],
        		      right: rightPercentage[artistName]
        		    }
        		    matchesCount++;
        		} else if (considerTheMismatches) {
        		    mismatchedArtists[artistName] = {
        		      left: leftPercentage[artistName]	
        		    }
        		    mismatchesCount++;
        		}
        	}
        	
        	if (considerTheMismatches) {
        	   for (artistName in rightPercentage) {
        	       	if (!matchedArtists[artistName] && !mismatchedArtists[artistName]) {
        	       		mismatchedArtists[artistName] = {
                          right: rightPercentage[artistName]  
                        }
                        mismatchesCount++;
        	       	}
        	   }
        	}
        	
        	var compatibilitySum = 0;
        	var maxCompatibiltySum = 0; 
            var matchedSongs = 0;
            var allSongsNum = 0;        	
        	for (artistName in matchedArtists) {
        		var matchedArtist = matchedArtists[artistName];
        		compatibilitySum += Math.min(matchedArtist.left.percent,
        		                             matchedArtist.right.percent);
        		maxCompatibiltySum += Math.max(matchedArtist.left.percent,
        		                               matchedArtist.right.percent);
        		matchedSongs += Math.min(matchedArtist.left.playcount,
                                         matchedArtist.right.playcount);
                allSongsNum += (parseInt(matchedArtist.left.playcount) + 
                                parseInt(matchedArtist.right.playcount));
        		if (matchReactionFunc) {
        			matchReactionFunc(artistName, matchedArtist);
        		}
        	}
        	
        	if (considerTheMismatches) {
        	   for (artistName in mismatchedArtists) {
                    var mismatchedArtist = mismatchedArtists[artistName];
                    var sumValue = mismatchedArtist.left ? 
                        mismatchedArtist.left : 
                        mismatchedArtist.right; 
                    // compatibilitySum += 0;
                    maxCompatibiltySum += sumValue.percent;
                    allSongsNum += parseInt(sumValue.playcount);                    
                    if (matchReactionFunc) {
                        matchReactionFunc(artistName, mismatchedArtist);
                    }
                }	
        	}
        	
        	var computedResult = compatibilitySum / (maxCompatibiltySum / 100);
        	        	
        	var artistsTotalNum = getPropsCount(leftPercentage) + 
        	           getPropsCount(rightPercentage) - matchesCount;
        	
        	if (compatibilityCalculatedFunc) 
        	   compatibilityCalculatedFunc(computedResult, 
        	                               //compatibilitySum,
        	                               //maxCompatibiltySum
        	                               matchedSongs,
        	                               allSongsNum,
        	                               matchesCount,
        	                               mismatchesCount,
        	                               artistsTotalNum);
        	
        	/* console.log(matchedArtists, mismatchedArtists,
        	   computedResult, compatibilitySum, maxCompatibiltySum); */
        	
        	return considerTheMismatches ? {
        		matched: matchedArtists,
        		mismatched: mismatchedArtists,
        		compatibility: computedResult
        	} : {
                matched: matchedArtists,
                compatibility: computedResult
            }
        	
        },
        
    initView:
        function() {
        	this.firstUsernameElm  = document.getElementById('first-username');
        	this.friendsListElm    = document.getElementById('friends-list');
        	this.friendsStatusElm  = this.friendsListElm.options[1]; // document.getElementById('friends-status');
        	this.secondUsernameElm = document.getElementById('second-username');
        	this.mismatchesChkbElm = document.getElementById('take-mismatches');
        	this.calculateBtnElm   = document.getElementById('calculate');        	
        	this.cancelProgressElm = document.getElementById('cancel-calculation');
        	this.userPgProgressElm = document.getElementById('user-page-progress');
        	this.friendProgressElm = document.getElementById('friends-load-progress');
        	
        	this.comparisonResultsElm     = document.getElementById('comparison-results');
        	
        	this._compareWithFriendsMode = true;
        	
            this.friendsListElm.selectedIndex = -1;
            this.firstUsernameElm.value = '%username%';
            this.secondUsernameElm.value = '%username%';
            this.userPgProgressElm.innerHTML = this.__getPageProgressInnerHTML(0, 0);
            this.friendProgressElm.innerHTML = this.__getFriendProgressInnerHTML(0, null);
        	
        	this.restoreAllElms();
        	
        	this.firstUsernameElm.onkeyup = function() {
                if (this.value.length > 0) {
        			cc.friendsListElm.disabled = false;
        			cc.friendsStatusElm.text = '[click here to get friends list]';
        			cc.friendsListElm.selectedIndex = 0;
        			cc.secondUsernameElm.disabled = false;
        			cc.calculateBtnElm.disabled = false;
        		} else {
                    cc.friendsListElm.disabled = true;
                    cc.friendsStatusElm.text = '[enter username]';
                    cc.friendsListElm.selectedIndex = -1;
                    cc.secondUsernameElm.disabled = true;
                    cc.calculateBtnElm.disabled = true;        			
        		}
        		cc._firstUsername = this.value;
        	}
        	
        	this.firstUsernameElm.onclick = function() {
        		this.value = '';
        		this.onkeyup(/*null*/);
        	}
        	
        	this.secondUsernameElm.onkeyup = function() {
        		if (this.value.length > 0) {        			
        			cc._compareWithFriendsMode = false;
        			cc.friendsListElm.className = 'inactive';
        			this.className = 'active';
        		} else {
        			cc._compareWithFriendsMode = true;
        			this.className = 'inactive';
        			cc.friendsListElm.className = 'active';
        		}
        		cc._secondUsername = this.value;
        	}
        	
            this.secondUsernameElm.onclick = function() {
                this.value = '';
                this.onkeyup(/*null*/);
            }
            
            this.friendsListElm.onclick = function(ev) {
                if (ev.target && (ev.target.id != 'friends-status')) {
                	cc._compareWithFriendsMode = true;
                	this.className = 'active';
                	cc.secondUsernameElm.className = 'inactive';
                }
            } 
        	
        	this.friendsStatusElm.onclick = function() {
        		if (!cc.__friendsReceivingLock) {        			
        			cc.__friendsReceivingLock = true;
            		cc.friendsStatusElm.text = '[getting friends...]';        		
            		if (cc.firstUsernameElm.value.length > 0) {
            		  cc.getFriends(cc.firstUsernameElm.value, 
            		      createMethodReference(cc, 'gotFriendsForTheList'),
            		      createMethodReference(cc, '__gettingFriendsForTheListError'));	
            		}
        		}
        	}
        	
        	this.mismatchesChkbElm.onclick = function() {
        		cc._takeMismatchedMode = this.checked;
        	}
        	
        	this.cancelProgressElm.onclick = function() {
                cc.__calculationCancelled = true;
                cc.restoreAllElms();
            }
        	
        	this.calculateBtnElm.onclick = function() {
        		cc.initCalculation();
        	}
        },
        
    __gettingFriendsForTheListError: // called when getting friends for the friends list process is failed
        function(error) {
        	this.__reportError(error);
        	cc.__friendsReceivingLock = false;        	
        },
        
    __gettingFriendsError: // called when getting friends while in calculation stage is failed
        function(error) {
        	this.__reportError(error);  
        },
        
    __friendsListFilter:
        function(lastFmFormatFriends) {
        	/* if (lastFmFormatFriends.length) {
        		var friendsList = [];
        		for (friendId in lastFmFormatFriends) {
        			friendsList.push({
        			    name: lastFmFormatFriends[friendId].name,
                        realname: lastFmFormatFriends[friendId].realname
        			});
        		}
        		return friendsList;
        	} else {
        		return [{
        			name: lastFmFormatFriends.name,
        			realname: lastFmFormatFriends.realname
        		  }];
        	} */
            return lastFmFormatFriends.length ? lastFmFormatFriends : [lastFmFormatFriends];
        },
        
    __artistStatsFilter:
        function(lastFmFormatArtists) {
        	// FIXME: check what happens if there is one artist
        	return lastFmFormatArtists;
        },

    __freeComparisonDataHolder:
        function() {
            this._comparisonDataHolder = [];
        },

    __storeMasterUserFriends: // called when friends are received while in the calculation stage
        function(friends, username) {
            // console.log(friends);           
            this.__freeComparisonDataHolder();
            this._comparisonDataHolder[0] = new UserComparisonDataHolder(username);
            this._comparisonDataHolder[0].friends = this.__friendsListFilter(friends);
        },        
        
    __makeFriendOption:
        function(friend) {
            var optionElm = document.createElement('option');
            optionElm.appendChild(document.createTextNode(friend.name));
            optionElm.value = friend.name;
            optionElm.id = 'friend-' + friend.name;
            optionElm.onclick = function() {
                cc.friendsListElm.options[0].selected = false;
            }
            var friendRealNameSpan = document.createElement('span');
            friendRealNameSpan.className = 'friend-real-name';
            friendRealNameSpan.appendChild(document.createTextNode(friend.realname));
            optionElm.appendChild(friendRealNameSpan);
            return optionElm;
        },        
        
    _extractFriendsFromList:
        function(selectElm, friendsSource) {
        	var resultArr = [];
        	for (optIdx in selectElm.options) {
        		if (selectElm.options[optIdx].selected) {
        			resultArr.push(friendsSource[optIdx - 2]);
        		}
        	}
        	return resultArr;
        },
        
    gotFriendsForTheList: // called when friends for the friends list are received
        function(friends, username) {
        	if (!friends || (friends.length == 0)) {
        		cc.friendsStatusElm.text = '[no friends found]';
        	}
        	this.__storeMasterUserFriends(friends, username); // store friends
            for (var i = cc.friendsListElm.options.length - 1; i >= 2; i--) {
            	cc.friendsListElm.remove(i);
            }
            
            if (friends) {
                if (friends.length) { // friends is array
                
                    for (friendId in friends) {
                    	cc.friendsListElm.appendChild(
                    	           cc.__makeFriendOption(friends[friendId]));
                    }
                
                } else { // friends is an object with one friend
                	
                	cc.friendsListElm.appendChild(cc.__makeFriendOption(friends));
                	
                } 
            }
            
            this.__friendsReceivingLock = false;
            if (friends && ((friends.length && (friends.length > 0)) || friends.name)) {
                cc.friendsStatusElm.text = '[select friends below]';
            }
            
            // TODO: sort friends by name
        },
        
    lockAllElms: 
        function() {
            this.firstUsernameElm.disabled = true;
            this.friendsListElm.disabled = true;
            this.friendsStatusElm.disabled = true;
            this.secondUsernameElm.disabled = true;
            this.mismatchesChkbElm.disabled = true;
            this.calculateBtnElm.disabled = true;
            this.cancelProgressElm.disabled = true;
            this.userPgProgressElm.disabled = true;
        },
        
    restoreAllElms: 
        function() {
            this.friendsStatusElm.disabled = true;
            this.friendsListElm.disabled = true;
            this.secondUsernameElm.disabled = true;
            this.cancelProgressElm.disabled = true;
            this.firstUsernameElm.disabled = false;
            this.mismatchesChkbElm.disabled = false;
            this.calculateBtnElm.disabled = false;
            this.userPgProgressElm.disabled = false;
            this.friendsListElm.className = 'active';   
            this.firstUsernameElm.className  = 'active';
            this.secondUsernameElm.className = 'inactive';
        },
        
    initCalculation:
        function() {        	
        	
        	this.lockAllElms();
        	
        	this.__calculationCancelled = false;
        	this.cancelProgressElm.disabled = false;
        	
        	// this.__percentageElmsHolder = {};
        	
        	// TODO: show smth like 'Wait, calculation in progress'
        	        	
            if (this._compareWithFriendsMode && (!this._comparisonDataHolder[0] || 
                    (this._comparisonDataHolder[0].username != this._firstUsername))) {
            	var storeFriendsFunc = createMethodReference(this, '__storeMasterUserFriends');            	
            	var startComparisonFunc = createMethodReference(this, '__startComparison');
            	var restoreElmsFunc = createMethodReference(this, 'restoreAllElms');
            	this.getFriends(this._firstUsername, 
            	                function (friends, username) {
            	                   storeFriendsFunc(friends, username);
            	                   startComparisonFunc(true, restoreElmsFunc);
            	                },
            	                createMethodReference(cc, '__gettingFriendsError'));
            	return;  
            }
            
            if (!this._compareWithFriendsMode) {
                this.__freeComparisonDataHolder();
                this._comparisonDataHolder[0] = new UserComparisonDataHolder(this._firstUsername);
            }
            
            this.__startComparison(this._compareWithFriendsMode,
                createMethodReference(this, 'restoreAllElms')/*,
                function(friendNum, totalFriends) {
                    cc.friendProgressElm.innerHTML = cc.__getPageProgressInnerHTML(friendNum, totalFriends);
                }*/);
        },
        
    __startComparison:
        function(compareWithFriends, onComplete, onEveryFriend) {
        	
            this.comparisonResultsElm.innerHTML = '';            
            this.__completedFriends = null;            
        	
            if (compareWithFriends) {
            	
            	var friends = null;
            	
            	if (this.friendsListElm.selectedIndex > 1) {
            		friends = this._extractFriendsFromList(this.friendsListElm,
            		          this._comparisonDataHolder[0].friends); 
            	} else {
            		friends = this._comparisonDataHolder[0].friends;
            	}
            	
            	// FIXME: if friends count is more than 10, make an alert that 
            	// calculation is allowed only for ten friends at a time
            	this.__friendsDataQueue = [];
            	this.__friendsInProgressCount = friends.length;
            	var friendPos = 1;
                if (onEveryFriend) onEveryFriend(0, friends.length);
            	for (friendId in friends) {
            		var friendsStatsDiv = this.__startPercentageLoadingFor(
            		    this._firstUsername, friends[friendId].name, this.comparisonResultsElm,
            		    compareWithFriends, {
            		    	pos: friendPos++,
            		    	total: friends.length
            		    }, function(friendIndex) {            		    	
                            cc.__friendsInProgressCount--;
                            if (onEveryFriend) onEveryFriend(friends.length - this.__friendsInProgressCount, friends.length);                            
            		    	// console.log('onComplete called with friendIdx ' + friendIndex +
            		    	         // 'in progress: ' + cc.__friendsInProgressCount);
            		    	if ((cc.__friendsInProgressCount == 0) || cc.__calculationCancelled) {
            		    	     if (onComplete) onComplete();
            		    	}
            		    	/*
                             * TODO: sort out the div's when all of data received (or in progress) 
                             *                              (store links, remove all and resort?)
                             */ 
            		    });            		    
            		  
            	}
            	
            } else { // compare with single user
            	
            	if (this._firstUsername == this._secondUsername) {
            	   this.__reportError('usernames must not be empty or identical');
            	   onComplete();
            	   return;
                } 
            	
            	// this._comparisonDataHolder[1] = new UserComparisonDataHolder(this._secondUsername);
            	this.__startPercentageLoadingFor(
                   this._firstUsername, this._secondUsername, this.comparisonResultsElm,
                           compareWithFriends, {
                              pos: 1,
                              total: 1
                           }, function() {
                                onComplete();
                           });
            	
            }
        },
        
     __startPercentageLoadingFor:
        function(username, friendName, holderElm, compareWithFriends, friendPosData, whenDone/*, whenGotData*/) {
        	var friendIndex = this._comparisonDataHolder.length;
        	
        	this._comparisonDataHolder[friendIndex] = new UserComparisonDataHolder(friendName);
        	
        	//console.log('started loading percentage for: ' + username + ' and ' + friendName,
        	  //     ', will store it in the cell# ' + friendIndex);
        	
            var userData = this._comparisonDataHolder[0];
        	var friendData = this._comparisonDataHolder[friendIndex];
        	
        	var compatibilityElems = this._createComparisonHolderElements(username, friendName);            
            holderElm.appendChild(compatibilityElems.holder);
            
            // console.log('created elm for friend #' + friendIndex, compatibilityElems.holder);
            
            var usersCompatibilityCalcFunc = function(userData, friendData, friendElems) {
            	// console.log('started compatibility calculation for friend #' + friendIndex);
                var userStats = cc.getPercentageStats(userData.artistsStats);
                var friendStats = cc.getPercentageStats(friendData.artistsStats);
                cc.calculateCompatibility(userStats, friendStats, 
                           cc._takeMismatchedMode, function(resultInPercent, 
                               matchedSongsSum, allSongsNum, artistsMatched,
                               artistsMismatched, allArtistsNum) {
                               cc._projectCompatibilityDataInElems(friendElems, {
                                       	    percentResult: resultInPercent,
                                       	    matchedSongs: matchedSongsSum,
                                       	    allSongs: allSongsNum,
                                       	    matchedArtists: artistsMatched,
                                       	    mismatchedArtists: artistsMismatched,
                                       	    allArtists: allArtistsNum
                                        });
                               // console.log('friend #' + friendIndex, resultInPercent, 
                               //matchedSongsSum, allSongsNum, artistsMatched,
                               //artistsMismatched);                               	
                               whenDone(friendIndex);
                           }, function(artistName, percentData) {
                               cc._appendArtistsPercentage(friendElems.comparisonListElm, artistName, percentData, friendName);
                           	   // console.log('friend #' + friendIndex, artistName, percentData);
                           });
                
            };
            
            var showPageProgressFunc = function(pageNum, totalPages, name, isFailed) {
            	if (name != cc._firstUsername) {
            	   compatibilityElems.pageProgressElm.innerHTML = cc.__getPageProgressInnerHTML(pageNum, totalPages);
            	} else {
            	   cc.userPgProgressElm.innerHTML = cc.__getPageProgressInnerHTML(pageNum, totalPages);
            	}
            	// TODO: show if the page failed to load
            	// console.log('got artists page for friend ' + name, pageNum, totalPages);
            };
            
            var showFriendProgressFunc = function(friendNum, totalFriends, justShow) {
            	// console.log('showing friend ' + friendNum + ' from ' + totalFriends);
            	if (!cc.__completedFriends) {
            	   cc.__completedFriends = new Array(totalFriends);
            	}
                if (!justShow) cc.__completedFriends[friendNum - 1] = true;            	
            	cc.friendProgressElm.innerHTML = cc.__getFriendProgressInnerHTML(friendNum, cc.__completedFriends);            	
            };
            
            if (friendPosData.pos == 1) { showFriendProgressFunc(friendPosData.pos, friendPosData.total, true); }
            
            if (!userData.artistsStats && !userData.statsLoadingInProgress) {
            	// console.log('no user artists stats are still received, so asking for them')
            	userData.statsLoadingInProgress = true;
                this.askUserArtistsStats(username, function(artists) {
                	userData.artistsStats = cc.__artistStatsFilter(artists);                	
                    userData.statsLoadingInProgress = false;
                    // console.log('got user data, checking friendData ' + friendData.artistsStats);
                    // if (whenGotData) whenGotData();
                    if (compareWithFriends) { 
                        for (friendId in cc.__friendsDataQueue) {
                           // console.log('loading data from queue' + cc.__friendsDataQueue[friendId]);
                           usersCompatibilityCalcFunc(userData, cc.__friendsDataQueue[friendId].data,
                                   cc.__friendsDataQueue[friendId].elems);
                        }
                        cc.__friendsDataQueue = null;
                    } else {
                        if (friendData.artistsStats) {
                           usersCompatibilityCalcFunc(userData, friendData, compatibilityElems);
                        }                    	
                    }
                }, showPageProgressFunc);
            }
            
            // console.log('asking for friend #' + friendIndex + ' stats');
            this.askUserArtistsStats(friendName, function(artists) {
            	    friendData.artistsStats = cc.__artistStatsFilter(artists);
                    // console.log('got user data (' + userData.artistsStats + '), checking friendData ' + friendData.artistsStats);
                    showFriendProgressFunc(friendPosData.pos, friendPosData.total);
                    // if (whenGotData) whenGotData();
                    if (userData.artistsStats && friendData.artistsStats) {
                        usersCompatibilityCalcFunc(userData, friendData, compatibilityElems);
                    } else {
                    	if (compareWithFriends && cc.__friendsDataQueue) {
                           // console.log('pushing data in queue');
                    	   cc.__friendsDataQueue.push({                    	   	
                        	   data: friendData,
                               elems: compatibilityElems
                           });
                    	}
                    	   
                    }
                }, showPageProgressFunc);
            
            /*
             * TODO: private/protected for these methods
             * TODO: sort out the div's when all of the data received (or while in progress) 
             *       (store links, remove all and resort?)
             */ 
            
             return compatibilityElems.holder;
        },
        
    _createComparisonHolderElements:
    	function(username, friendName) {
            var newFriendStats = document.createElement('div');
            newFriendStats.className = 'friend-comparison fold';                  
            newFriendStats.id = username + '-' + friendName + '-cmp';
            
            var percentageTitle = document.createElement('h2');
            percentageTitle.className = 'unknown';    
                var namesSpan = document.createElement('span');
                namesSpan.className = 'usernames';
                    var userSpan = document.createElement('span');
                    userSpan.className = 'first-username';
                    userSpan.appendChild(document.createTextNode(username));
                namesSpan.appendChild(userSpan);
                namesSpan.appendChild(document.createTextNode(' — '));
                    var friendSpan = document.createElement('span');
                    friendSpan.className = 'second-username';
                    friendSpan.appendChild(document.createTextNode(friendName));
                namesSpan.appendChild(friendSpan);
                namesSpan.appendChild(document.createTextNode(': '));
            percentageTitle.appendChild(namesSpan);
                var pageProgress = document.createElement('span');
                // pageProgress.id = username + '-' + friendName + '-pprogress';
                pageProgress.className = 'page-progress-container';
            percentageTitle.appendChild(pageProgress);
                var compatibilityBlock = document.createElement('span');
                compatibilityBlock.id = username + '-' + friendName + '-datablock';
                compatibilityBlock.className = 'compatibility';
                    var compatibilityValue = document.createElement('span');
                    //compatibilityValue.id = username + '-' + friendName + '-compatibility';
                    compatibilityValue.className = 'comptb-val';
                    compatibilityValue.appendChild(document.createTextNode('0%'));
                compatibilityBlock.appendChild(compatibilityValue);
                compatibilityBlock.appendChild(document.createTextNode(' ('));
                    var matchedSongsValue = document.createElement('span');
                    // matchedSongsValue.id = username + '-' + friendName + '-matched';
                    matchedSongsValue.className = 'comptb-matched';
                    matchedSongsValue.appendChild(document.createTextNode('0'));
                compatibilityBlock.appendChild(matchedSongsValue);
                compatibilityBlock.appendChild(document.createTextNode('/'));
                    var songsNumValue = document.createElement('span');
                    // songsNumValue.id = username + '-' + friendName + '-songsnum';
                    songsNumValue.className = 'comptb-songsnum';
                    songsNumValue.appendChild(document.createTextNode('0'));
                compatibilityBlock.appendChild(songsNumValue);
                compatibilityBlock.appendChild(document.createTextNode(')'));
            percentageTitle.appendChild(compatibilityBlock);
                var artistsMatchedBlock = document.createElement('span');
                artistsMatchedBlock.className = 'artists-match-data';
                    var artistsMatchedValue = document.createElement('span');
                    // artistsMatchedValue.id = username + '-' + friendName + '-artmatch';
                    artistsMatchedValue.className = 'artists-matched';
                    artistsMatchedValue.appendChild(document.createTextNode('?'));
                artistsMatchedBlock.appendChild(artistsMatchedValue);
              if (this._takeMismatchedMode) {
                artistsMatchedBlock.appendChild(document.createTextNode(':'));
                    var artistsMismatchedValue = document.createElement('span');
                    // artistsMismatchedValue.id = username + '-' + friendName + '-artmismatch';
                    artistsMismatchedValue.className = 'artists-mismatched';
                    artistsMismatchedValue.appendChild(document.createTextNode('?'));
                artistsMatchedBlock.appendChild(artistsMismatchedValue);
              }
                artistsMatchedBlock.appendChild(document.createTextNode('/'));
                    var artistsNumValue = document.createElement('span');
                    // artistsNumValue.id = username + '-' + friendName + '-artall';
                    artistsNumValue.className = 'artists-num';
                    artistsNumValue.appendChild(document.createTextNode('?'));
                artistsMatchedBlock.appendChild(artistsNumValue);
            percentageTitle.appendChild(artistsMatchedBlock);
            newFriendStats.appendChild(percentageTitle);
            
            var comparisonList = document.createElement('dl');
            comparisonList.id = username + '-' + friendName + '-holder';
            comparisonList.className = 'artists-list';
            
            newFriendStats.appendChild(comparisonList);
            
            percentageTitle.onclick = function() {
                if (newFriendStats.className.indexOf('unfold') >= 0) {
                    newFriendStats.className = 'friend-comparison fold';
                } else {
                    newFriendStats.className = 'friend-comparison unfold';
                }
            }                        
            
            return {
            	holder: newFriendStats,
            	// compatibilityContainer: compatibilityBlock,
            	compValueElm: compatibilityValue,
            	matchedSongsElm: matchedSongsValue,
            	songsNumElm: songsNumValue,
            	// artistsMatchedContainer: artistsMatchedBlock,
            	artistsMatchedElm: artistsMatchedValue,
            	artistsMismatchedElm: artistsMismatchedValue,
            	artistsNumElm: artistsNumValue,
            	pageProgressElm: pageProgress,
            	comparisonListElm: comparisonList,
            	titleHolderElm: percentageTitle
            }
    	   
        },
        
    _appendArtistsPercentage: 
        function(element, artistName, percentData/*, friendName*/) {
               var artistNameElm = document.createElement('dt');
               artistNameElm.appendChild(document.createTextNode(artistName));                                 
           element.appendChild(artistNameElm);
               var percentageHolder = document.createElement('dd');
                   var artistPercentage = document.createElement('ul');
                   artistPercentage.className = ((percentData.left && percentData.right) ? 'matched' : 'unmatched') + '-artist';
                 if (percentData.left) {
                 	  var percentValue = (Math.round(percentData.left.percent*100)/100);
                      var leftPercentageElm = document.createElement('li');
                      leftPercentageElm.className = 'left-percentage';
                          var leftPercentageSpan = document.createElement('span');
                          leftPercentageSpan.className = 'percentage';
                          leftPercentageSpan.appendChild(document.createTextNode(
                                  percentValue + '%\u00a0(' + percentData.left.playcount + ')'
                              ));
                      leftPercentageElm.appendChild(leftPercentageSpan);
                      leftPercentageElm.style.width = percentValue + '%';
                   artistPercentage.appendChild(leftPercentageElm);
                 }
                 if (percentData.right) {
                 	  var percentValue = (Math.round(percentData.right.percent*100)/100);
                      var rightPercentageElm = document.createElement('li');
                      rightPercentageElm.className = 'right-percentage';
                          var rightPercentageSpan = document.createElement('span');
                          rightPercentageSpan.className = 'percentage';
                          rightPercentageSpan.appendChild(document.createTextNode(
                                  percentValue + '%\u00a0(' + percentData.right.playcount + ')'
                              ));
                          if (percentValue < 5) rightPercentageSpan.className += ' right-shift';
                      rightPercentageElm.appendChild(rightPercentageSpan);
                      rightPercentageElm.style.width = percentValue + '%';
                   artistPercentage.appendChild(rightPercentageElm);                   
                 }
               percentageHolder.appendChild(artistPercentage);
           element.appendChild(percentageHolder);
                      
           /*if (!this.__percentageElmsHolder[friendName]) 
                this.__percentageElmsHolder[friendName] = [];
           this.__percentageElmsHolder[friendName].push({
           	    leftValue:  percentData.left,
           	    leftElm:    leftPercentageElm,
                rightValue: percentData.right,
                rightElm:   rightPercentageElm       	    
           }); */
        },
        
    _projectCompatibilityDataInElems:
        function(elems, cmpData) {
           /* 
           compatibilityValue.innerHTML = (Math.round(resultInPercent*100)/100) + '%';
           matchedSongsValue.innerHTML = matchedSongsSum;
           songsNumValue.innerHTML = allSongsNum;
           artistsMatchedValue.innerHTML = artistsMatched;
           if (cc._takeMismatchedMode) 
                artistsMismatchedValue.innerHTML = artistsMismatched;
           artistsNumValue.innerHTML = allArtistsNum; */
           elems.compValueElm.innerHTML = (Math.round(cmpData.percentResult*100)/100) + '%';
           elems.matchedSongsElm.innerHTML = cmpData.matchedSongs;
           elems.songsNumElm.innerHTML = cmpData.allSongs;
           elems.artistsMatchedElm.innerHTML = cmpData.matchedArtists;
           if (this._takeMismatchedMode) 
                elems.artistsMismatchedElm.innerHTML = cmpData.mismatchedArtists;
           elems.artistsNumElm.innerHTML = cmpData.allArtists;
           elems.titleHolderElm.className = 'found';
        },
        
    __getPageProgressInnerHTML:
        function(currentPage, totalPages, isFailed) {
        	if (totalPages != 0) {
            	var pageSymb = '■'; // '●' // '•';
            	var blankPageSymb = '□';
            	var lineWidth = 20; // in symbols
            	var makeBreaks = true;
            	var breakSymbol = ' '; // '<br/>'        	
            	var innerHTML = '<span class="page-progress"><span class="pages-complete">';
            	for (var pageCursor = 0; pageCursor < totalPages; pageCursor++) {
            		if (pageCursor == currentPage) {
            			innerHTML += '</span>' + ((makeBreaks && ((pageCursor % lineWidth) == 0)) ? breakSymbol : '') + 
            			           '<span class="' + (isFailed ? 'page-failed' : 'page-current') + '">' + 
            			           pageSymb + '</span><span class="pages-not-complete">';
            		} else {
            			innerHTML += ((makeBreaks && (pageCursor % lineWidth) == 0) ? breakSymbol : '') + pageSymb;
            		}
            	}
            	if (makeBreaks) {
                	innerHTML += '</span><span class="pages-blank">';
                	while ((pageCursor % lineWidth) != 0) {
                		innerHTML += blankPageSymb;
                		pageCursor++;
                	}
            	}
            	innerHTML += '</span></span>';
            	return innerHTML;
        	} else return '<span class="unknown">[&hellip;]</span>';        	
        },
        
   __getFriendProgressInnerHTML:
        function(currentFriend, completedFriendsArr) {        	
        	if (completedFriendsArr) { 
            	// console.log('inner', currentFriend, completedFriendsArr);
                var friendSymb = '■'; // '●' // '•';
                var blankfriendSymb = '□';
                var lineWidth = 20; // in symbols
                var makeBreaks = true;
                var breakSymbol = ' '; // '<br/>' 
            	innerHTML = '<span class="friend-progress">';
            	for (var friendCursor = 0; friendCursor < completedFriendsArr.length; friendCursor++) {
            		var isComplete = (completedFriendsArr[friendCursor] === true);
                    if (makeBreaks && ((friendCursor % lineWidth) == 0)) innerHTML += breakSymbol;            		
                    innerHTML += '<span class="' + (isComplete ? 'friend-complete' : 'friend-not-complete') + '">';
                    innerHTML += friendSymb + '</span>';
            	}
                if (makeBreaks) {
                    innerHTML += '<span class="friends-blank">';
                    while ((friendCursor % lineWidth) != 0) {
                        innerHTML += blankfriendSymb;
                        friendCursor++;
                    }
                    innerHTML += '</span>';
                }            	
            	innerHTML += '</span>';
            	return innerHTML;
        	} else return '<span class="unknown">[&hellip;]</span>';
        	// TODO: show current and failed friends;
        }/*,
        
        
    __alignFriendPercentWidths:
        function(friendName) {
        	var percentData = this.__percentageElmsHolder[friendName];
            for (artistId in percentData) {
            	var artistBlock = percentData[artistId];
            	artistBlock.leftElm.style.width = 
                              Math.round(artistBlock.leftElm.offsetWidth / 100 * 
                                    artistBlock.leftElm.leftValue) + 'px'; 
            }
        
        }*/

}
