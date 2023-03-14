import http from "../http-common"
class TokenDataService {
    newToken(email, password) {
        return http.post("/register", {
            "name": email,
            "email": email,
            "password": password,
            "password_confirmation": password
        });
    }
}

export default new TokenDataService();