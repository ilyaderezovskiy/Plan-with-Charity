import React, { useState, useContext, useEffect } from "react";
import Avatar from '@mui/material/Avatar';
import Stack from '@mui/material/Stack';
import { Text } from "react-native-web";
import { blue, deepOrange, deepPurple } from '@mui/material/colors';
import './Profile.css';
import Typography from '@mui/material/Typography';
import { TouchableOpacity } from 'react-native';
import { Button } from "react-native-web";
import Input from '@mui/material/Input';
import { fontSize } from "@mui/system";
import TextField from '@mui/material/TextField';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import { Linking } from "react-native";
import { Button as MyButton, CardActionArea, CardActions } from '@mui/material';
import { auth } from "../config";

export const Profile = ({ navigation }) => {

    const [sum, setSum] = useState(500);
    const changeSum = (newSum) => setSum(newSum);

    const [organization, setOrganization] = React.useState('');
    const handleChange = (event) => {
        setOrganization(event.target.value);
    };

    const handleSignOut = () => {
        auth
          .signOut()
          .then(() => {
            navigation.navigate("AuthPage");
          })
          .catch(error => alert(error.message))
    }
    

    return (
        <div className="Profile">
            <form>
        <Stack direction="column" spacing={2} textAlign='left' alignItems="center">
            <Avatar sx={{ bgcolor: blue[500], width: 106, height: 106, marginTop: 4 }}>I</Avatar>
            <Typography variant="h5" gutterBottom>
                Ilya
            </Typography>
            <Typography variant="body1" gutterBottom>
                Накопленная сумма: {sum}
            </Typography>
            <span
                onClick={() => {
                  if (window.confirm("Вы действительно сбросить накопленную сумму?")) {
                    changeSum(0);
                  }
                }}
                className="material-icons-outlined text-gray-500 cursor-pointer"
            >
                <Typography variant="caption" display="block" gutterBottom>
                    Сбросить
                </Typography>
            </span>
            <Typography variant="body1" gutterBottom>
                Выбранная благотворительная организация:
            </Typography>
            <FormControl fullWidth>
        <InputLabel id="demo-simple-select-label">Организация</InputLabel>
        <Select
          labelId="demo-simple-select-label"
          id="demo-simple-select"
          value={organization}
          label="Organization"
          onChange={handleChange}
        >
          <MenuItem value={'https://mayak.help/help/'}>Дом с маяком</MenuItem>
          <MenuItem value={'https://fondvera.ru/donate/'}>Вера</MenuItem>
        </Select>
      </FormControl>

      <span
        onClick={() => {
            if(organization !== '') {
                Linking.openURL(organization);
                changeSum(0);
            } else {
                window.alert("Для перевода необходимо выбрать благотворительную организацию");
            }
        }}
        className="material-icons-outlined text-gray-500 cursor-pointer"
        >
            <MyButton
                type="button"
                variant="contained"
                disableElevation={true}
                sx={{
                    marginTop: 1,
                    width: '345px'
                }}
            >
                Перевести
            </MyButton>
        </span>

        {/* <span
        onClick={() => {
            if(organization !== '') {
                Linking.openURL(organization);
                changeSum(sum - 1);
            } else {
                window.alert("Для перевода необходимо выбрать благотворительную организацию");
            }
        }}
        className="material-icons-outlined text-gray-500 cursor-pointer"
        >
            <MyButton
                type="button"
                variant="contained"
                disableElevation={true}
                sx={{
                    marginTop: 1,
                    width: '345px'
                }}
            >
                Перевести часть суммы
            </MyButton>
        </span>
        <TextField 
            id="outlined-basic"
            type="number"
            defaultValue="0"
            label="Outlined"
            onChange={(e) => {
                var value = parseInt(e.target.value, 10);
                if(!value) {
                    window.alert("???");
                    value=0;
                }
      
                if (value < 0) {
                    window.alert("!!!");
                }
                if (value > sum) value = 0;
      
                changeSum(sum - value);
              }}
            variant="outlined" /> */}
    </Stack>
    {/* <Card sx={{ maxWidth: 285 }}>
      <CardActionArea>
        <CardMedia
          component="img"
          height="140"
          image="url(./House_logo.jpg)"
          alt="Дом с маяком"
        />
        <CardContent>
          <Typography gutterBottom variant="h6" component="div">
            Дом с маяком
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Lizards are a widespread group of squamate reptiles, with over 6,000
            species, ranging across all continents except Antarctica
          </Typography>
        </CardContent>
      </CardActionArea>
      <CardActions>
        <MyButton size="small" color="primary">
          Перевести
        </MyButton>
      </CardActions>
    </Card> */}
    <span
        onClick={() => {
            handleSignOut()
        }}
        className="material-icons-outlined text-gray-500 cursor-pointer"
    >
        <Typography variant="body1" gutterBottom>
            Выйти из аккаунта
        </Typography>
    </span>
    </form>
    </div>
    )
}