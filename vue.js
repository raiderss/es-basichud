const app = new Vue({
  el: '#app',
  data: {
    ui:false,
    location:{ StreetName1:'', StreetName2:''},
    notification:[],
    stats:'car', // civilian // car
    hud: {
      health: {
        status: 0,
      },
      armor : {
        status:0
      },
      hunger: {
        status: 0
      },
      water : {
        status:0
      },
    },
  },
  computed: {
    healthTransformValue() {
      return this.calculateMaxHeight(this.hud.health.status, 'health');
    },
    armorTransformValue() {
      return this.calculateMaxHeight(this.hud.armor.status, 'armor');
    },
    hungerTransformValue() {
      return this.calculateMaxHeight(this.hud.hunger.status, 'hunger');
    },
    waterTransformValue() {
      return this.calculateMaxHeight(this.hud.water.status, 'water');
    }
  },
  methods: {
    animateLocation() {
      const text1 = this.$refs.text1;
      const text2 = this.$refs.text2;
      anime.timeline({ loop: false })
        .add({
          targets: text1,
          translateY: ['-2rem', 0], 
          opacity: [0, 1],  
          duration: 500,
          easing: 'easeOutExpo',
          delay: 300,  
        })
        .add({
          targets: text2,
          translateY: ['-2rem', 0],
          opacity: [0, 1],
          duration: 500,
          easing: 'easeOutExpo',
          delay: 200,  
        });
    },    
      position(type) {
        let translateXValue = '0rem'; 
    
        switch(type) {
            case 'civilian':
                translateXValue = '-16.5rem';
                break;
            case 'car':
                translateXValue = '0rem';  
                break;
        }
    
        anime.timeline({
            targets: this.$refs.animate,
            easing: 'easeOutElastic(1, .8)', 
        })
        .add({
            translateX: translateXValue, 
            duration: 800
        })
        .add({
            rotate: ['0deg', '1deg', '-1deg', '0deg'], 
            duration: 300
        });
    },  
    calculateMaxHeight(value, type) {
      const BASE_TRANSLATE = 29;  
      const multiplier = {
          hunger: 0.41,
          water: 0.51,
          health: 0.37,
          armor: 0.5
      };
      const heightValue = value * multiplier[type];
      const calculatedHeight = BASE_TRANSLATE - heightValue;
      return calculatedHeight;
  },  
  },

  created() {
    var self = this;
    window.addEventListener('message', function(event) {
      const item = event.data;
      const actions = {
        "HEALTH&ARMOR": () => {
          self.hud.health.status = item.health;
          self.hud.armor.status = item.armor;
        },
        "WATER": () => {
          self.hud.water.status = item.water;
        },
        "HUNGER": () => {
          self.hud.hunger.status = item.hunger;
        },
        "STREET": () => {
          self.location = item;
        },
        "NOTIFICATION": () => {
          self.notification.push({
            label: item.label,
            description: item.description
          });
          setTimeout(() => {
            self.notification.pop();
          }, 5000);
        },
        "STATUS": () => {
          if (item.variable){
            self.position('car')
          }else {
            self.position('civilian')
          }
        },
        "CONNECTED": () => {
          self.ui = true;
        }
      };
      const actionFunc = actions[item.action];
      if (actionFunc) actionFunc();
    });
  },  

  
  watch: {
    'location': {
      deep: true,
      handler: function(newVal, oldVal) {
        console.log(newVal, oldVal);
        this.$nextTick(() => {
          this.animateLocation();
        });
      }
    },
    'hud.health.status': function() {
      this.triggerAnimation();
    },
    'hud.armor.status': function() {
      this.triggerAnimation();
    },
    'hud.hunger.status': function() {
      this.triggerAnimation();
    },
    'hud.water.status': function() {
      this.triggerAnimation();
    },
    'notification':function(data){
      anime({
        targets: this.$refs.notificationDiv,
        keyframes: [
          { scale: 1.1, duration: 200 },
          { scale: 0.9, duration: 200 },
          { scale: 1, duration: 200 }
        ],
        easing: 'easeOutQuad'
      });
    }
  },
  mounted() {document.onkeyup = data => {
      if (data.which == 27) {
        this.menu(false);
        $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
      }
    };
  }
});
