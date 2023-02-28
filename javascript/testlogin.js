    var headers = {
        "Content-Type": "application/json"
    };
    var url = "https://pvwa.acme.corp";
    var uri = url + "/PasswordVault/api/Auth/cyberark/Logon";
    var body = {
        username: "SafeFactory",
        password: "Cyberark1",
        concurrentSession: "false"
    };
    var response = http.post(uri, headers, body);
    headers.Authorization = response;
    console.log(response);
