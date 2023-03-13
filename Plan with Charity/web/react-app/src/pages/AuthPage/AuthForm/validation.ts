const REQUIRED_FIELD = 'Обязательно для заполнения';

export const loginValidation = {
    required: REQUIRED_FIELD,
    validate: (value: string) => {
        
        if(value.length < 2) {
            return 'Логин должен быть длиннее 1-ого символа'
        }
        if(!/[а-яa-zA-ZА-Я]/.test(value)) {
            return 'Логин должен содержать хотя бы одну букву'
        }
        if(/^(?![а-яa-zA-ZА-Я0-9]+$).*$/.test(value)) {
            return 'Логин должен содержать только буквы или цифры'
        }
        if(/[ ]/.test(value)) {
            return 'Необходимо удалить пробелы'
        }

        return true;
    }
};

export const emailValidation = {
    required: REQUIRED_FIELD,
    validate: (value: string) => {
        if(!/[@]/.test(value)) {
            return 'Некорректный email (@)'
        }
        if(!/[.]/.test(value)) {
            return 'Некорректный email (.)'
        }
        if(value.split("@").length != 2) {
            return 'Некорректный email (@)'
        }

        var firstPart = value.split("@")[0]
        var secondPart = value.split("@")[1]

        if(/^(?![а-яa-zA-ZА-Я0-9.+-]+$).*$/.test(firstPart)) {
            return 'Некорректный email'
        }
        if(secondPart.split(".").length != 2) {
            return 'Некорректный email'
        }

        if(secondPart.split(".")[0].length < 1 || secondPart.split(".")[1].length < 1) {
            return 'Некорректный email'
        }

        if(!/[а-яa-z.]/.test(secondPart)) {
            return 'Некорректный email'
        }
        if(/[ ]/.test(value)) {
            return 'Необходимо удалить пробелы'
        }
        if(/^(?![а-яa-z.]+$).*$/.test(secondPart)) {
            return 'Некорректный email'
        }

        return true;
    }
};

export const passwordValidation = {
    required: REQUIRED_FIELD,
    validate: (value: string) => {
        if(value.length < 6) {
            return 'Пароль должен быть длиннее 6-ти символов'
        }
        if(!/[а-яa-zA-ZА-Я]/.test(value)) {
            return 'Пароль должен содержать хотя бы одну букву'
        }
        if(!/[0-9]/.test(value)) {
            return 'Пароль должен содержать хотя бы одну цифру'
        }
        if(!/[(?=.*!@#$%^&*)]/.test(value)) {
            return 'Пароль должен содержать хотя бы один спецсимвол'
        }
        if(!/[A-ZА-Я]/.test(value)) {
            return 'Пароль должен содержать хотя бы одну заглавную букву'
        }
        if(/[ ]/.test(value)) {
            return 'Необходимо удалить пробелы'
        }

        return true;
    }
};