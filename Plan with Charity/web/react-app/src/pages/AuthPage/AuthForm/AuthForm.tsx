import { Typography } from "@mui/material";
import './AuthForm.css';
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import React, { useEffect, useState, useCallback, useContext } from "react";
import { loginValidation, emailValidation, passwordValidation } from "./validation.ts";
import { Controller, useForm, SubmitHandler, useFormState } from 'react-hook-form';
// import { Button }  from 'react-native';
import { auth } from "../../../config";
import { StyleSheet, KeyboardAvoidingView, Image, Pressable, TouchableOpacity, TextInput, Text, View } from 'react-native';
import firebase from "firebase";
require("firebase/firestore");
require('firebase/storage')

interface ISignInForm {
    login: string;
    email: string;
    password: string;
}

export const AuthForm = ({ navigation }) => {
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
    const [name, setName] = useState('')
    const [currentEmail, setCurrentEmail] = useState('')

    const firestore = firebase.firestore();
    const { handleSubmit, control } = useForm<ISignInForm>();
    const { errors } = useFormState({
        control
    });
    const onSubmit: SubmitHandler<ISignInForm> = (data) => console.log(data);

    const handleChangeEmail = (event) => {
        setEmail(event.target.value)
    };
    
    const handleChangePassword = (event) => {
        setPassword(event.target.value)
    };

    const handleChangeName = (event) => {
        setName(event.target.value)
    };

    const handleSignUp = () => {
        auth
          .createUserWithEmailAndPassword(email, password)
          .then(userCredentials => {
            const user = userCredentials.user;
    
            firestore.collection("users").add({
              email: email,
              login: name
            })
            
            navigation.navigate("Calendar");
            })
            .catch(error => alert(error.message))
        }
    
      const handleLogin = () => {
        auth
          .signInWithEmailAndPassword(email, password)
          .then(userCredentials => {
            const user = userCredentials.user;

            navigation.navigate("Calendar");
          })
          .catch(error => alert(error.message))
      }

    return (
        <div className="AuthForm">
            <form className="AuthForm_Form" onSubmit={handleSubmit(onSubmit)}>
                <Controller
                    control={ control }
                    name="login"
                    rules={ loginValidation }
                    render={({ field }) => (
                        <TextField
                            label="Логин"
                            id="standard-start-adornment"
                            sx={{ mt: 3, width: '360px' }}
                            variant="standard"
                            onChange={(e) => {field.onChange(e); handleChangeName(e)}}
                            value={ field.value }
                            error={ !!errors.login?.message }
                            helperText={ errors.login?.message }
                        />
                    )}
                />
                <Controller
                    control={ control }
                    name="email"
                    rules={ emailValidation }
                    render={({ field }) => (
                        <TextField
                            label="Электронная почта"
                            id="standard-start-adornment"
                            sx={{ m: 1, width: '360px' }}
                            variant="standard"
                            onChange={(e) => {field.onChange(e); handleChangeEmail(e)}}
                            value={ field.value }
                            error={ !!errors.email?.message }
                            helperText={ errors.email?.message }
                        />
                    )}
                />
                <Controller
                    control={ control }
                    name="password"
                    rules={ passwordValidation }
                    render={({ field }) => (
                        <TextField
                            label="Пароль"
                            id="standard-start-adornment"
                            sx={{ width: '360px' }}
                            variant="standard"
                            onChange={(e) => {field.onChange(e); handleChangePassword(e)}}
                            value={ field.value }
                            error={ !!errors.password?.message }
                            helperText={ errors.password?.message }
                        />
                    )}
                />
                <Button
                    type="submit"
                    variant="contained"
                    onClick={() => { handleLogin() }}
                    disableElevation={true}
                    sx={{
                        marginTop: 4,
                        width: '345px'
                    }}
                >
                    Войти
                </Button>
                <Button
                    type="submit"
                    variant="contained"
                    onClick={() => { handleSignUp() }}
                    disableElevation={true}
                    sx={{
                        marginTop: 1,
                        width: '345px'
                    }}
                >
                    Зарегистрироваться
                </Button>
            </form>
        </div>
    )
}