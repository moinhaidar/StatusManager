'use strict';
StatusApp.factory('Status', function($resource){
    return $resource('/status/:id', {id: '@id'})
})