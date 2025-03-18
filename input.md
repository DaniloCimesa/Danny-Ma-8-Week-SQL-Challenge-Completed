```
#using input function
message=input('Tell  me something and I will repeat it:')

print(message)

#more modified input

name=input('Hello what is your name: ')

print(f'Hello {name}')

#more longer input

prompt = "If you tell us who you are, we can personalize the messages you see."
prompt += "\nWhat is your first name? "

names=input(prompt)

print(f'Hello {names}')

#input int

age=input('How old are you: ')
print(age)

age>=17

#this returns an error because input is a string

age=int(age)

age>=16

#with an if block

height=input('Please input your height, in cm:')
height=int(height)

if height>180:
    print('Enjoy your ride!')
else:
    print('You have to be 180 or more cm tall to go on this ride')
    
#moduo
#leftover division

4%3
```
<img width="450" alt="image" src="https://github.com/user-attachments/assets/d188b7ad-39b3-4c47-a3da-1d5bcc4f3858" />

```
#7.1

wanted_car=input('Please tell us what kind of car you want and we will look if we have it:')
print(f'Let me see if we have a {wanted_car} in our warehouse')

#7.2

guests=input('Please tell us how many people will be joining you tonight:')
guests=int(guests)

if guests>8:
    print("You'll have to wait for us to get your table ready")
else:
    print('Your table is ready')
    
#7.3

num=input('Please input a number:')
num=int(num)

if num%10==0:
    print('Correct')
else:
    print('Wrong')
```
