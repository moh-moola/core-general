*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  HttpLibrary.HTTP
Library  REST

*** Variables ***
${AUTHENTICATION_SERVICE_API_KEY} =  Get Environment Variable  AUTHENTICATION_SERVICE_API_KEY
&{AUTH_HOST}  local=localhost:8000  docker=core-authentication-service:8000  qa=authentication-service.qa-hub.ie.gehosting.org
&{ACCESS_HOST}  qa=access-control-service.qa-hub.ie.gehosting.org

*** Keywords ***
Change Site State
    [Documentation]  Set the user 'is_active' flag to true/false.
    [Arguments]  ${site_id}  ${state}

    RequestsLibrary.Create Session  hook  https://${ACCESS_HOST.${ENVIRONMENT}}  verify=${True}
    RequestsLibrary.Create Session  status  https://${ACCESS_HOST.${ENVIRONMENT}}  verify=${True}

    # Do the PUT request:
    ${body} =  Create Dictionary  is_active=${state}
    ${headers} =  Create Dictionary  Accept=application/json  Content-Type=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Put Request  hook  /api/v1/sites/${site_id}  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

    # Check that the flag has been set correctly:
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Get Request  status  /api/v1/sites/${site_id}  headers=${headers}
    Should be Equal  ${resp.json()["is_active"]}  ${state} 

Get Access Token
    RequestsLibrary.Create Session  hook  https://${AUTH_HOST}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp} =  RequestsLibrary.Post Request  hook  /openid/token/  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${accessToken} =  evaluate  $resp.json().get("access_token")
    Set Global Variable  ${accessToken}

Get ID Token
    RequestsLibrary.Create Session  hook  http://${AUTH_HOST}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp} =  RequestsLibrary.Post Request  hook  /openid/token/  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${accessToken} =  evaluate  $resp.json().get("id_token")
    #Log to Console  ${accessToken}
    Set Global Variable  ${idToken}

Change User State
    [Documentation]  Set the user 'is_active' flag to true/false.
    [Arguments]  ${UserData}  ${state}

    RequestsLibrary.Create Session  hook  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}
    RequestsLibrary.Create Session  status  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}

    # Do the PUT request:
    ${body} =  Create Dictionary  is_active=${state}
    ${headers} =  Create Dictionary  Accept=application/json  Content-Type=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Put Request  hook  /api/v1/users/${UserData.id}  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

    # Check that the flag has been set correctly:
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Get Request  status  /api/v1/users/${UserData.id}  headers=${headers}
    Should be Equal  ${resp.json()["is_active"]}  ${state}

Delete User
    [Documentation]  Remove user via API
    [Arguments]  ${UserData}

    Get User ID  ${UserData}

    RequestsLibrary.Create Session  delete  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Delete Request  delete  /api/v1/users/${User_ID}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

Put Null Email Field
    [Documentation]  Set the user 'email' flag to null to remove it from the response body.
    [Arguments]  ${UserData}

    RequestsLibrary.Create Session  hook  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}
    RequestsLibrary.Create Session  status  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}

    # Do the PUT request:
    ${body} =  Create Dictionary  email=${UserData.email}
    ${headers} =  Create Dictionary  Accept=application/json  Content-Type=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Put Request  hook  /api/v1/users/${UserData.id}  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

Put MSISDN
    [Documentation]  Add an msisdn to a user's profile.
    [Arguments]  ${UserData}  ${msisdn}

    RequestsLibrary.Create Session  hook  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}
    RequestsLibrary.Create Session  status  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}

    # Do the PUT request:
    ${body} =  Create Dictionary  msisdn=${msisdn}
    ${headers} =  Create Dictionary  Accept=application/json  Content-Type=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Put Request  hook  /api/v1/users/${User_ID}  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

Get User ID
    [Documentation]  GET existing user ID.
    [Arguments]  ${UserData}

    RequestsLibrary.Create Session  hook  https://${AUTH_HOST.${ENVIRONMENT}}  verify=${True}

    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Get Request  hook  /api/v1/users?username=${UserData.username}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp.id} =  Get Json Value  ${resp.content}  /0/id
    ${User_ID} =  Remove String  ${resp.id}  "
    Set Global Variable  ${User_ID}

Get Site Roles
    RequestsLibrary.Create Session  hook  http://${host}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${AUTHENTICATION_SERVICE_API_KEY}
    ${resp} =  RequestsLibrary.Get Request  hook  /api/v1/ops/tech_admin_resource_permissions  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    Log  ${resp.content}
    #Dictionary Should Contain Value  ${resp.json()}  ["permission_id"]

rest get token
   REST.POST  https://${AUTH_HOST.${ENVIRONMENT}}/openid/token  body={"grant_type":"password","client_id":"872786","client_secret":"bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058","username":"jasonb","password":"12QWas\!\@","scope":"openid%20site%20roles%20email"}
   Set Headers  {"Content-Type":"application/x-www-form-urlencoded"}
   #Output  response body
   Integer  response status  200
   ${rest_token} =  String  response body access_token
   #Set Headers   {"Authorization":"JWT ${jwt_token}"}
   Log  ${rest_token}

rest get user id
    REST.GET  https://${AUTH_HOST.${ENVIRONMENT}}/api/v1/users?username=robot
    Set Headers  {"Accept" : "application/json"}
    Set Headers  {"X-API-Key" : "${AUTHENTICATION_SERVICE_API_KEY}"}
    Output  response
    Integer  response status  200
    #Array       response body
    ${something} =  response body 0 id
    Log  ${something}
    #Integer     response body 0 id        1
    #[Teardown]  Output  response body 0
