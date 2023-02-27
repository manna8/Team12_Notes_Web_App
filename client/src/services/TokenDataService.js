
class TokenDataService {
    newToken(email, paasword) {
        return http.post("/token", {
            "email": email,
            "password": paasword
        });
    }
}

export default new TokenDataService();