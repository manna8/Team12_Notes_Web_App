import http from "../http-common"
class TokenDataService {
    newToken(email, password) {
        return http.post("/token", {
            "email": email,
            "password": password
        });
    }
}

export default new TokenDataService();