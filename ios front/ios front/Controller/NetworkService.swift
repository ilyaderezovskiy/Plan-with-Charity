//
//  NetworkService.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 06.04.2023.
//

import Foundation

class NetworkService: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var organizations: [Organization] = []
    @Published var sum: Int = 0
    
    static let shared = NetworkService();
    
    private init() { }
    
    private let localhost = "http://127.0.0.1:8080"
    
    // Авторизация пользователя
    func auth(login: String, email: String, password: String) async throws -> User {
        let dto = UserDTO(login: login, email: email, password: password)
        
        guard let url = URL(string: "\(localhost)\(APIMethod.auth.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let userResponse = try await URLSession.shared.data(for: request)
        let userData = userResponse.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: userData)
        return user
    }
    
    // Регистрация пользователя
    func signup(id: String?, login: String, email: String, password: String, sum: Int) async throws -> User {
        let dto = UserNEW(id: id, username: login, email: email, passwordHash: password, sum: sum)
        
        guard let url = URL(string: "\(localhost)\(APIMethod.signup.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let userResponse = try await URLSession.shared.data(for: request)
        let userData = userResponse.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: userData)
        return user
    }
    
    // Получение всех благотворительных организаций
    func getOrganizations() -> [Organization] {
        
        let url = URL(string: "\(localhost)\(APIMethod.organizations.rawValue)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching task: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let organizations = try JSONDecoder().decode([Organization].self, from: data)
                self.organizations = organizations
            } catch {
                print("Error decoding organization: \(error)")
                return
            }
        }.resume()
        return self.organizations
    }
    
    // Получение всех задач пользователя по id
    func getTasks(userID: String) -> [TaskModel] {
        
        let url = URL(string: "\(localhost)\(APIMethod.tasks.rawValue)\(userID)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching task: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let task = try JSONDecoder().decode([TaskModel].self, from: data)
                self.tasks = task
            } catch {
                print("Error decoding task: \(error)")
                return
            }
        }.resume()
        return self.tasks
    }
    
    // Получение информации о пользователе по id
    func getUser(userID: String) -> Int {
        
        let url = URL(string: "\(localhost)\(APIMethod.signup.rawValue)\(userID)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching task: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let task = try JSONDecoder().decode(User.self, from: data)
                self.sum = task.sum
            } catch {
                print("Error decoding task: \(error)")
                return
            }
        }.resume()
        return self.sum
    }
    
    // Удаление задачи пользователя по id
    func deleteTask(taskID: String) {
        
        let url = URL(string: "\(localhost)\(APIMethod.tasks.rawValue)\(taskID)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching task: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed!!!!!!!")
                return
            }
        }.resume()
    }
    
    // Удаление пользователя по id
    func deleteUser(userID: String) {
        
        let url = URL(string: "\(localhost)\(APIMethod.signup.rawValue)\(userID)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching task: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed!!!!!!!")
                return
            }
        }.resume()
    }
    
    // Добавление новой задачи пользователя
    func addTask(task: TaskModel) async throws {
        
        let dto = TaskNEW(id: task.id, userID: task.userID, title: task.title, time: task.time, cost: task.cost, description: task.description, category: task.category, isDone: task.isDone, isOverdue: task.isOverdue)
        
        let url = URL(string: "\(localhost)\(APIMethod.tasks.rawValue)")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let userResponse = try await URLSession.shared.data(for: request)
        let userData = userResponse.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(TaskModel.self, from: userData)
    }
    
    // Редактирование задачи пользователя
    func editTask(task: TaskModel) async throws {
        
        let dto = TaskNEW(id: task.id, userID: task.userID, title: task.title, time: task.time, cost: task.cost, description: task.description, category: task.category, isDone: task.isDone, isOverdue: task.isOverdue)
        
        let url = URL(string: "\(localhost)\(APIMethod.tasks.rawValue)\(task.id)")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let userResponse = try await URLSession.shared.data(for: request)
        let userData = userResponse.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(TaskModel.self, from: userData)
    }
    
    // Редактирование информации о пользователе
    func editUser(user: User) async throws {
        
        let dto = User(id: user.id, username: user.username, sum: user.sum)
        
        let url = URL(string: "\(localhost)\(APIMethod.signup.rawValue)\(user.id)")
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let userResponse = try await URLSession.shared.data(for: request)
        let userData = userResponse.0
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: userData)
    }
}

struct UserDTO: Codable {
    let login: String
    let email: String
    let password: String
}

struct UserNEW: Codable {
    let id: String?
    let username: String
    let email: String
    let passwordHash: String
    let sum: Int
}

struct TaskNEW: Codable {
    let id: String
    let userID: String
    let title: String
    let time: String
    let cost: Int
    let description: String
    let category: String
    let isDone: Bool
    let isOverdue: Bool
}

enum APIMethod: String {
    case auth = "/users/auth"
    case signup = "/users/"
    case tasks = "/tasks/"
    case organizations = "/organizations"
}

enum NetworkError: Error {
    case badURL
}

